Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab1LIAMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 19:12:00 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53061 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156Ab1LIAL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 19:11:56 -0500
X-Sasl-enc: 8+Fb/ZYaG2GVmtnw+BP2slzmxcWor6am2zAWOUIdX0i2 1323389512
Date: Thu, 8 Dec 2011 16:11:45 -0800
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, trenn@suse.de,
        davej@redhat.com
Subject: Re: [PATCH-WIP] convert CPU sysdev class to a real subsytem (needed
 for CPU modaliases)
Message-ID: <20111209001145.GB9550@kroah.com>
References: <1323309517.979.8.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1323309517.979.8.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 02:58:37AM +0100, Kay Sievers wrote:
> This patch is work-in-progress and just posted to coordinate with Andi
> Kleen's current export of CPU modaliases. It boots my x86_64 workstation
> fine, nothing else is tested.
> 
> The CPU subsystem from a sysdev_class to a plain driver-core subsystem
> (currently called 'bus').
> 
> With the CPUs as normal devices, userspace will pick the events up
> properly and udev is able to coldplug the devices during bootup, which
> will allow proper module autoloading based on MODALIAS.
> 
>   $ tree /sys/bus/cpu/
>   /sys/bus/cpu/
>   ├── devices
>   │   ├── cpu0 -> ../../../devices/system/cpu/cpu0
>   │   ├── cpu1 -> ../../../devices/system/cpu/cpu1
>   │   ├── cpu2 -> ../../../devices/system/cpu/cpu2
>   │   └── cpu3 -> ../../../devices/system/cpu/cpu3
>   ...
>   └── uevent
> 
> The needed bits to easily convert the remaining sysdev class users to a
> plain subsystem and plain devices have been added to the driver core.
> Sysdev drivers have never been 'drivers' in the driver-core sense, and
> they can be now ported-over to subsys_interfaces. The end goal is to
> finally remove all of the ugly sysdev hack from the system.
> 
> Greg, I guess we need a bit of your time, to make a plan and get the
> remaining things sorted out. We are planning and fiddling for years
> already here, and we should finally get the stuff out. :)

I agree, I want this to get done finally.

> Greg, I think with the subsys_interfaces we do not need the
> 'multi-driver-binding' anymore, seems we can get away with the
> interfaces only. Classes which need to convert to buses because the
> class interface is not extensible can be easily converted now. The only
> missing piece is the 'glue directory'. We should be able to unify
> classes and buses internally with all that stuff.

Ah, good, I was stalled on this because of the multi-driver-binding
stuff.  If that's not needed, I'll gladly take any patches for this.

So, what do I need to do here?  Your patch looks good at first glance,
the interface logic looks sane, is that all that we really need to do to
the core?

thanks,

greg k-h
