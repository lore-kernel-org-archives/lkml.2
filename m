Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab1GMWLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:11:43 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40449 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1GMWLl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:11:41 -0400
References: <4E1B978C.2030407@psychogeeks.com> <20110712080309.d538fec9.rdunlap@xenotime.net> <7B814F02-408C-434F-B813-8630B60914DA@wilsonet.com> <4E1CCC26.4060506@psychogeeks.com> <1B380AD0-FE0D-47DF-B2C3-605253C9C783@wilsonet.com> <4E1D3045.7050507@psychogeeks.com>
In-Reply-To: <4E1D3045.7050507@psychogeeks.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Message-Id: <2E869B1F-D476-4645-BE26-B1DD77DF1735@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Imon module Oops and kernel hang
Date: Wed, 13 Jul 2011 18:11:22 -0400
To: Chris W <lkml@psychogeeks.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 13, 2011, at 1:42 AM, Chris W wrote:

> 
> On 13/07/11 14:20, Jarod Wilson wrote:
> 
>>> Chris W wrote:
>>> The rc keymap modules have been built (en masse as a result of
>>> CONFIG_RC_MAP=m) but I am not explicitly loading them and they do not
>>> get automatically loaded.
>> 
>> Huh. That's unexpected. They get auto-loaded here, last I knew. I'll
>> have to give one of my devices a spin tomorrow, not sure exactly what
>> the last kernel I tried one of them on was. Pretty sure they're
>> working fine with the Fedora 15 2.6.38.x kernels and vanilla (but
>> Fedora-configured) 3.0-rc kernels though.
> 
> 
> I just ran depmod to make sure things were straight in this dept.
> 
> kepler ~ # depmod -F System.map -e -av 2.6.39.3
> 
> There are no reported errors.   The modules rc-imon-mce.ko,
> rc-imon-pad.ko and imon.ko depend only on rc-core.ko according to the
> output.  There don't seem to be any explicit dependencies to the keymaps
> (not a kernel dev so I don't know if there should be)

Yeah, imon depends on rc-core, and requests its keymap via rc-core, so
rc-core should then load up rc-imon-pad. Just tried on 3.0-rc7+ here,
and everything is happy:

[10791.866789] imon 3-2:1.0: usb_probe_interface
[10791.868944] imon 3-2:1.0: usb_probe_interface - got id
[10791.871332] input: iMON Panel, Knob and Mouse(15c2:0042) as /devices/pci0000:00/0000:00:03.1/usb3/3-2/3-2:1.0/input/input18
[10791.916037] Registered IR keymap rc-imon-pad
[10791.918709] input: iMON Remote (15c2:0042) as /devices/pci0000:00/0000:00:03.1/usb3/3-2/3-2:1.0/rc/rc6/input19
[10791.921331] rc6: iMON Remote (15c2:0042) as /devices/pci0000:00/0000:00:03.1/usb3/3-2/3-2:1.0/rc/rc6
[10791.930038] imon 3-2:1.0: iMON device (15c2:0042, intf0) on usb<3:3> initialized
[10791.932507] imon 3-2:1.1: usb_probe_interface
[10791.934949] imon 3-2:1.1: usb_probe_interface - got id
[10791.937416] imon 3-2:1.1: iMON device (15c2:0042, intf1) on usb<3:3> initialized
[10791.939996] usbcore: registered new interface driver imon

Just noticed your report is for 2.6.39.x and 2.6.38.x only, but I'm not
aware of any relevant imon changes between 2.6.39 and 3.0.

>>> Perhaps there something else in the kernel config that must be on in
>>> order to support the keymaps?
>>> 
>>> Any other thoughts?
>> 
>> Not at the moment. That T.889 line is... odd. No clue what the heck
>> that thing is. Lemme see what I can see tomorrow (just past midnight
>> here at the moment), if I don't hit anything, I might need a copy of
>> your kernel config to repro.
> 
> I can only see the "T.889" string in the System.map, kernel binary and
> kernel/sched.o (but not the source?).  I have sent the config file
> off-list to Jarod.

Looks like I'll probably have to give that a spin, since I'm not seeing
the problem here (I can also switch to an 0xffdc device, which is actually
handled a bit differently by the driver).

-- 
Jarod Wilson
jarod@wilsonet.com



