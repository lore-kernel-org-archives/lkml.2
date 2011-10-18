Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab1JROAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:00:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54144 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964Ab1JROAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:00:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/6] drivers/base: add bus for System-on-Chip devices
Date: Tue, 18 Oct 2011 16:00:03 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        jamie@jamieiles.com, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org> <2152965.Ns7xt0yLIG@wuerfel> <20111017182542.GB14416@suse.de>
In-Reply-To: <20111017182542.GB14416@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201110181600.03834.arnd@arndb.de>
X-Provags-ID: V02:K0:CwI0B1ArbhA+wNQuHlQaqPFdAhT/68kEC/uHAnUNwNN
 2N0LiS22GwChg7gJCSU+x3d2tEKlgMuB6H6Fql7N16ImEucorb
 XX6yrboHAbfK92gzWy1n56Af9oBNQ15sKxjGBZ8Ffp6I7sOMJn
 fv3L/d8MXw3ryLpVsbd9RNqUeaN8sSLSbPkk50v4cpv5xAcZmW
 oItR/QdU9mzzu9bSwhoz/wu7v1tomwsWXD85lctE45a2p5MBuI
 KQ7srvGpOBo/CGZF2fQFYCaTi0DtL5EKgaaIKqMVw3hpO1iwQb
 BwM6ffEW+joE12RvvlKGX7TYsZFa3zwV9blFJM8J/T+JrT6ymf
 V3oB94XJkLap+nhYkGL8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 October 2011, Greg KH wrote:
> > You also commented that the argument to soc_device_unregister should
> > be a soc_device (as, consequently, the return type of soc_device_register).
> > Agree with that comment, but it means that the definition of struct
> > soc_device needs to remain visible in order to be used as the parent
> > for other devices.
> 
> No it doesn't:
>         struct device * soc_device_to_device(struct soc device *soc);

Right, that works of course. I believe the more common way is to
expose the derived type to its users, and it also simplifies the
interface.

> Anyway, what are you using this soc device to be the parent of?

Basically everything. The SoC is probably about 90% of the system in
modern embedded systems. Typically, there are on-chip buses like
AMBA or PLB that contain dozens of internal devices (interrupt
controller, serial, dmaengine, rtc, timer, watchdog, ...) as well
as buses (i2c, spi, mmc, usb, pci, ...) that have off-chip child
devices. You can think of an soc device as a kind of über-MFD
that holds all of these together.

If you remember the early discussions about this patch set, I
specifically asked for making the soc_device be a representation
of the whole soc with a hierarchical view of its child devices
under it, as opposed to having an artificial device node that only
serves to export strings along the lines of /proc/cpuinfo.

See patch 5/6 for the one that moves all platform devices that
are part of the dbx500 soc below the soc_device.

	Arnd
