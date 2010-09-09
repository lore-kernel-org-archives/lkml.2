Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0IIXo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:44:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64103 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab0IIXo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 19:44:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bg7g3ry151iyI9wvexFu3bhDe9nmUkDTwtIkGEodFUVbZyBhfwnGigpXqW1uEXf7/N
         kvtDTCvredShpgctX72Cp9xf+kYBZ3Aitp+Y/HUXmfO95XOla49ndE67jrP2ZKS5n5bR
         q+LBJgHgkP5F2ovrrh33dSNB/HrDkwfM/ypMI=
MIME-Version: 1.0
In-Reply-To: <87wrqu8s1u.fsf_-_@spindle.srvr.nix>
References: <87zkvx2ese.fsf@spindle.srvr.nix>
	<20100906053255.GA23340@brouette>
	<87iq2gyllg.fsf@spindle.srvr.nix>
	<87wrqu8s1u.fsf_-_@spindle.srvr.nix>
Date: Thu, 9 Sep 2010 19:44:55 -0400
Message-ID: <AANLkTinSr0xoRrtZ6R+sRyQbf0LXhqBJisQTcdHc+A8+@mail.gmail.com>
Subject: Re: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown to
 unusability (HPET)
From: John Drescher <drescherjm@gmail.com>
To: Nix <nix@esperi.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> John, Damien, you seem to be experiencing this: are you using HPET as
> your clocksource? Do you also have ICH10 82801JIs, or is this more
> widespread?
>
I am not using hpet as my clocksource.

jmd1 ~ # uname -a
Linux jmd1 2.6.35-std160-amd64 #2 SMP Fri Aug 13 18:42:02 UTC 2010
x86_64 Intel(R) Core(TM) i7 CPU 920 @ 2.67GHz GenuineIntel GNU/Linux
jmd1 ~ # cat /sys/devices/system/clocksource/clocksource0/current_clocksource
tsc

I do have ICH10 82801JI

jmd1 ~ # lspci -v | grep 82801JI
00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #4 (prog-if 00 [UHCI])
        Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI
Controller #4
00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #5 (prog-if 00 [UHCI])
        Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI
Controller #5
00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #6 (prog-if 00 [UHCI])
        Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI
Controller #6
00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #2 (prog-if 20 [EHCI])
        Subsystem: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI
Controller #2
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD
Audio Controller
        Subsystem: Intel Corporation 82801JI (ICH10 Family) HD Audio Controller
00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
Express Root Port 1 (prog-if 00 [Normal decode])
        Capabilities: [90] Subsystem: Intel Corporation 82801JI (ICH10
Family) PCI Express Root Port 1
00:1c.1 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
Express Port 2 (prog-if 00 [Normal decode])
        Capabilities: [90] Subsystem: Intel Corporation 82801JI (ICH10
Family) PCI Express Port 2
00:1c.2 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
Express Root Port 3 (prog-if 00 [Normal decode])
        Capabilities: [90] Subsystem: Intel Corporation 82801JI (ICH10
Family) PCI Express Root Port 3
00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
Express Root Port 5 (prog-if 00 [Normal decode])
        Capabilities: [90] Subsystem: Intel Corporation 82801JI (ICH10
Family) PCI Express Root Port 5
00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #1 (prog-if 00 [UHCI])
        Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI
Controller #1
00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #2 (prog-if 00 [UHCI])
        Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI
Controller #2
00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #3 (prog-if 00 [UHCI])
        Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI
Controller #3
00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #1 (prog-if 20 [EHCI])
        Subsystem: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI
Controller #1
00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
        Subsystem: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA
AHCI Controller (prog-if 01 [AHCI 1.0])
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
        Subsystem: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
jmd1 ~ #
