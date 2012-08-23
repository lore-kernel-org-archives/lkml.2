Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768Ab2HWIe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 04:34:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:34597 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933726Ab2HWIeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 04:34:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,299,1344236400"; 
   d="scan'208";a="184039674"
Date: Thu, 23 Aug 2012 16:28:52 +0800
From: Feng Tang <feng.tang@intel.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: Re: i2c-eg20t: regression since i2c_add_numbered_adapter change
Message-ID: <20120823162852.29243e9c@feng-i7>
In-Reply-To: <24029861.U7thTLuEmC@ws-stein>
References: <4401854.hVfHzgeqjT@ws-stein>
	<3514180.RWySLZuOJm@ws-stein>
	<20120822160439.62c619bf@feng-i7>
	<24029861.U7thTLuEmC@ws-stein>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 22 Aug 2012 11:17:51 +0200
Alexander Stein <alexander.stein@systec-electronic.com> wrote:

> Hello,
> 
> Am Mittwoch, 22. August 2012, 16:04:39 schrieb Feng Tang:
> > > Why use a fixed one? Give the driver (and maybe every i2c bus driver) a parameter which sets the base bus number it should use.
> > > E.g. i2c-eg20t.base-bus-num=2 so it will register the bus numbers starting from 2. If this parameter is unset. It would use the first free one, thus simply using i2c_add_adapter.
> > 
> > The reason we need a fixed number is it is easier for platform code
> > which needs to register dozens of i2c devices to different controllers
> > with i2c_register_board_info, and they need provide a bus number for
> > each i2c device, this _binding_ info is not detectable but have to
> > be fixed.
> 
> Yes, I'm aware of that. With "Why use a fixed one?" I meant why hard-code it into the driver. I should be changeable.
> Because this is/was not possible in general to use i2c_register_board_info, so we used an echo to /sys/bus/i2c/devices/i2c-0/new_device or /sys/bus/i2c/devices/i2c-1/new_device.

Yeah, our EG20T kernel used to use the same "echo /sys/bus/i2c/devices/i2c-x/new_device"
way, but we found out it is not convenient for:
1. needs extra user space script, why not make it just work in kernel after
boot? We have several i2c devices like touchscreen/radio which we wants them
just work without depending user space action.
2. The i2c bus number is not fixed, which make the user space script even
harder, as that number depends whether we compile into kernel all the i2c
controllers (eg20t and isch) and whether these driver are compiled as
modules and their loading order.

Thus we come out with this fixed bus number registering.

As I said before, either your module parameter "base_bus_num" solution
or my fixed bus number offset are ok to me. Will you cook a patch?

Thanks,
Feng

