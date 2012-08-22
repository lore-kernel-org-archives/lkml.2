Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab2HVJR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:17:57 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:59759 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195Ab2HVJRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:17:53 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Feng Tang <feng.tang@intel.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: Re: i2c-eg20t: regression since i2c_add_numbered_adapter change
Date: Wed, 22 Aug 2012 11:17:51 +0200
Message-ID: <24029861.U7thTLuEmC@ws-stein>
User-Agent: KMail/4.8.5 (Linux/3.3.8-gentoo; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20120822160439.62c619bf@feng-i7>
References: <4401854.hVfHzgeqjT@ws-stein> <3514180.RWySLZuOJm@ws-stein> <20120822160439.62c619bf@feng-i7>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am Mittwoch, 22. August 2012, 16:04:39 schrieb Feng Tang:
> > Why use a fixed one? Give the driver (and maybe every i2c bus driver) a parameter which sets the base bus number it should use.
> > E.g. i2c-eg20t.base-bus-num=2 so it will register the bus numbers starting from 2. If this parameter is unset. It would use the first free one, thus simply using i2c_add_adapter.
> 
> The reason we need a fixed number is it is easier for platform code
> which needs to register dozens of i2c devices to different controllers
> with i2c_register_board_info, and they need provide a bus number for
> each i2c device, this _binding_ info is not detectable but have to
> be fixed.

Yes, I'm aware of that. With "Why use a fixed one?" I meant why hard-code it into the driver. I should be changeable.
Because this is/was not possible in general to use i2c_register_board_info, so we used an echo to /sys/bus/i2c/devices/i2c-0/new_device or /sys/bus/i2c/devices/i2c-1/new_device.

> Yes, your module parameter "base-bus-num" sounds like a plan too,
> at the cost of some extra setting in the kernel cmdline. And I'm fine
> with all solutions as long as I can get a _fixed_ bus number so that
> I can easily write the platform config code (I guess this is same
> for device tree, and even ACPI 5.0)

i2c_add_numbered_adapter only works reliably if only using a single driver. If you are using several, especially if one uses dynamic bus numbers, you're kinda screwed.
So, not very driver can add busses starting at bus number 0.
I guess using an Intel Atom (i2c-isch) with an eg20t is not that uncommon, so you'll end up using 2 drivers where each one should have a fixed number.
Some mechanism like udev for renaming ethernet or block devices is needed here.

Regards,
Alexander

