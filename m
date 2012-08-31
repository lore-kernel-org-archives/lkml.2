Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2HaCWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 22:22:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:41689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab2HaCWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 22:22:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,344,1344236400"; 
   d="scan'208";a="139957180"
Date: Fri, 31 Aug 2012 10:16:58 +0800
From: Feng Tang <feng.tang@intel.com>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Jean Delvare <khali@linux-fr.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: Re: i2c-eg20t: regression since i2c_add_numbered_adapter change
Message-ID: <20120831101658.5ec81fa2@feng-i7>
In-Reply-To: <6208908.ZjG7eB9lJn@ws-stein>
References: <4401854.hVfHzgeqjT@ws-stein>
	<4378288.tkkLiQ5MQ7@ws-stein>
	<20120830171915.36b6d10b@feng-i7>
	<6208908.ZjG7eB9lJn@ws-stein>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Thu, 30 Aug 2012 13:08:09 +0200
Alexander Stein <alexander.stein@systec-electronic.com> wrote:

> On Thursday 30 August 2012 17:19:15, Feng Tang wrote:
> > > IMO the i2c_register_board_info only works in quite static setups. Especially with I2C-Busses attached to hotplugable PCI devices this way doesn't work reliable any more.
> > > The device come and go dynamically so you can't assume fixed mapping.
> > 
> > Can you specify the hotplugable?
> > 1. A hotplugable i2c bus controller (say i2c_eg20t) with all fixed i2c
> >  devices connecting to it
> > 2. i2c bus controller is fixed, while the i2c devices will be dynamically
> >  connected to it.
> > 3. Both the bus controller and devices are dynamically hotplugged
> 
> I had scenario 1 in mind, but with more than 1 bus controller (say 2x i2c_eg20t). How can you set a fixed numbering if there are more controllers, each with maybe more than 1 bus?
> Anyway, how can you provide a static bus numbering if there are more than one driver or more than one device per driver if the devices are hotplugable?

There is no problem for one pci driver to support multiple devices with
same HW, if you check i2c-eg20t.c you can check the pch_pcidev_id[], there
is a ML7213 platform which has 2 i2c controllers already. With current
in tree driver, they will get fixed bus number 0 and 1.

For the scenario 1, if you have really have another hotplugable pci eg20t
controller, it surely will have its unique PCI id, and then we can use
the "driver_data" of struct pci_device_id to point to a platform info
structure like

struct i2c_eg20t_platform_info {
	u16	bus_base_num;
	u16	total_hw_num;
}

And for EG20T compatible platform, I don't think it will have too many
fancy hotplugable different type of i2c controller other than i2c_eg20t
and i2c_sch.

Thanks,
Feng
