Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab2KMVmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:42:55 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:32765 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2KMVmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:42:54 -0500
Date: Tue, 13 Nov 2012 22:42:46 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Till Harbaum <till@harbaum.org>
Subject: Re: [PATCH 1/2] i2c: Add possibility for user-defined (i2c-)devices
  for bus-drivers.
Message-ID: <20121113224246.768bf734@endymion.delvare>
In-Reply-To: <50A2BAA2.6090009@ahsoftware.de>
References: <1352829968-4908-1-git-send-email-holler@ahsoftware.de>
	<20121113195533.6db71716@endymion.delvare>
	<50A2AC28.7050304@ahsoftware.de>
	<20121113220835.111a178a@endymion.delvare>
	<50A2BAA2.6090009@ahsoftware.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012 22:24:50 +0100, Alexander Holler wrote:
> Am 13.11.2012 22:08, schrieb Jean Delvare:
> > It probes in the sense "check if a device is present", not in the sense
> > "check if the device there is really what the user told me." So very
> > easy to get wrong. Plus there is no universal probe method on I2C,
> > i2c_new_probed_device() uses a default heuristic which may not only
> > fail to detect a device's presence, but may even heavily confuse the
> > device in question. Usage of i2c_new_probed_device() should be limited
> > to very specific cases.
> 
> I know about that too. But I prefer such a probe instead of doing it 
> without an probe. Just try what happens if you add e.g. an pcf8563 (or 
> ds1307) which is not available. The driver doesn't care and you will 
> find an /dev/rtcN afterwards in your system. So probing is imho better 
> than not.

Question is, what will you do the day someone wants to instantiate a
device for which the default probing mechanism doesn't work?

Plus you don't address the main issues. Your syntax gives you no way to
support two i2c-tiny-usb adapters with different chips at a specific
address. The sysfs interface supports such a setup. Also instantiating
the wrong devices is worse than instating a device that doesn't exist
at all. So the use of i2c_new_probed_device() here will randomly help
in a limited number of cases and randomly be problematic in others.
Hard to justify...

> > I am not questioning the quality of your code, I did not even look at
> > it. I'm questioning the pertinence of adding yet another way to
> > instantiate i2c devices when we already have 4 which made everybody
> > else happy for the past 3 years AFAIK.
> 
> As said, currently there is no way to do that whithout either patching 
> the kernel or working in userspace. And a RTC is just an example for a 
> device you really want before userspace starts (but imho a very good).

I am not familiar with RTC constraints. What is so important about it
that it can't wait for user-space? It'll have to wait for the USB and
I2C stacks to initialize anyway, so it won't be available at the very
early stages of the boot.

-- 
Jean Delvare
