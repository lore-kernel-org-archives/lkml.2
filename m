Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab1I2NoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:44:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43224 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab1I2NoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:44:16 -0400
Date: Thu, 29 Sep 2011 14:44:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Long stalls during boot with -next
Message-ID: <20110929134416.GB2085@sirena.org.uk>
References: <20110929125035.GA2085@sirena.org.uk>
 <s5hfwjfa4df.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hfwjfa4df.wl%tiwai@suse.de>
X-Cookie: Whip it, whip it good!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 03:02:20PM +0200, Takashi Iwai wrote:
> Mark Brown wrote:

> > (which happens before or at about the time console output starts
> > appearing, I'd expect it to appear much earlier).  I've had a poke
> > around and I didn't spot anything yet, none of the development I've
> > noticed going on recently looks suspicious.

> Did you check with initcall_debug boot option?

Oh, I forgot to mention - that appears to make the 10s delay go down to
5s which isn't terribly helpful - it looks like the additional logging
causes some substantial reordering of some of the asynchronous parts of
boot, mainly the USB probe and accessory detection which previously
Completed earlier.  It does also appear that some of the user visible
delay here is coming prior to the kernel taking over so probably some
ARM boot code is taking a chunk of time also.

[    2.130000] wm831x-rtc wm831x-rtc.10: hctosys: unable to read the hardware clock
[    2.130000] initcall rtc_hctosys+0x0/0x120 returned -22 after 0 usecs
[    2.130000] initcall rtc_hctosys+0x0/0x120 returned with error code -22 
[    2.140000] calling  net_secret_init+0x0/0x24 @ 1
[    2.140000] initcall net_secret_init+0x0/0x24 returned 0 after 0 usecs
[    2.140000] calling  tcp_congestion_default+0x0/0x1c @ 1
[    2.140000] initcall tcp_congestion_default+0x0/0x1c returned 0 after 0 usecs
[    2.140000] calling  ip_auto_config+0x0/0x224 @ 1
[    2.140000] initcall ip_auto_config+0x0/0x224 returned 0 after 0 usecs
[    2.140000] calling  initialize_hashrnd+0x0/0x24 @ 1
[    2.140000] initcall initialize_hashrnd+0x0/0x24 returned 0 after 0 usecs
[    2.150000] async_waiting @ 1
[    2.150000] async_continuing @ 1 after 0 usec
[    2.240000] usb 1-1.1: udev 3, busnum 1, minor = 2
[    2.240000] usb 1-1.1: New USB device found, idVendor=0424, idProduct=2514
[    2.240000] usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber
=0
[    2.250000] usb 1-1.1: usb_probe_device
[    2.250000] usb 1-1.1: configuration #1 chosen from 1 choice
[    2.250000] usb 1-1.1: adding 1-1.1:1.0 (config #1, interface 0)
[    2.250000] hub 1-1.1:1.0: usb_probe_interface
[    2.250000] hub 1-1.1:1.0: usb_probe_interface - got id
[    2.250000] hub 1-1.1:1.0: USB hub found
[    2.260000] hub 1-1.1:1.0: 4 ports detected
[    2.260000] hub 1-1.1:1.0: standalone hub
[    2.260000] hub 1-1.1:1.0: individual port power switching
[    2.260000] hub 1-1.1:1.0: individual port over-current protection
[    2.260000] hub 1-1.1:1.0: power on to power good time: 100ms
[    2.260000] hub 1-1.1:1.0: local power source is good
[    2.260000] hub 1-1.1:1.0: enabling power on all ports
[    2.270000] drivers/usb/core/inode.c: creating file '003'
[    2.270000] hub 1-1:1.0: state 7 ports 4 chg 0000 evt 0002
[    2.370000] hub 1-1.1:1.0: state 7 ports 4 chg 0000 evt 0000
[    2.970000] wm8996 1-001a: Microphone event: 402
[    2.970000] wm8996 1-001a: Jack removal detected
[    9.270000] kjournald starting.  Commit interval 5 seconds
