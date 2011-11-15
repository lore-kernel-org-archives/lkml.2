Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab1KOXDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:03:18 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33534 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755826Ab1KOXDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:03:14 -0500
X-Sasl-enc: UfrGFt8jxyjV+U51ZhQ6fb/FcmVyaxqN/k2EVwx7YfV/ 1321398193
Date: Tue, 15 Nov 2011 21:03:06 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tom Gundersen <teg@jklm.no>
Cc: maciej.rutecki@gmail.com, Natanji <natanji@gmail.com>,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Regression in thinkpad-acpi events
Message-ID: <20111115230305.GA23325@khazad-dum.debian.net>
References: <4EBAC3B5.5060405@gmail.com>
 <201111142031.06663.maciej.rutecki@gmail.com>
 <4EC16F8E.7060601@gmail.com>
 <201111142118.47256.maciej.rutecki@gmail.com>
 <CAG-2HqVnsmSyHVCvEVf+sZw5NxhR8qSDDB0AtR+igwCCFiwfgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG-2HqVnsmSyHVCvEVf+sZw5NxhR8qSDDB0AtR+igwCCFiwfgQ@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >> This can be observed by using the acpi_listen command. For instance, no
> >> >> ACPI events happen when swiveling the display, and the sleep button
> >> >> returns
> >> >>
> >> >>    button/sleep SBTN 00000080 00000000
> >> >>
> >> >> instead of the previous
> >> >>
> >> >>    ibm/hotkey HKEY 00000080 00001004
> >> >>
> 
> I'm observing the same, also with Arch Linux, and a ThinkPad x60:
> # uname -a
> Linux x60 3.1.1-1-ARCH #1 SMP PREEMPT Fri Nov 11 22:28:29 CET 2011
> x86_64 Intel(R) Core(TM)2 CPU T7200 @ 2.00GHz GenuineIntel GNU/Linux
> 
> The kernel config can be found here:
> <http://projects.archlinux.org/svntogit/packages.git/tree/trunk?h=packages/linux>.
> 
> As requested:
> # grep . /sys/bus/platform/devices/thinkpad*/*
> /sys/bus/platform/devices/thinkpad_acpi/hotkey_enable:1
> /sys/bus/platform/devices/thinkpad_acpi/hotkey_mask:0x008dffff
> /sys/bus/platform/devices/thinkpad_acpi/hotkey_poll_freq:10
> /sys/bus/platform/devices/thinkpad_acpi/hotkey_radio_sw:1
> /sys/bus/platform/devices/thinkpad_acpi/hotkey_recommended_mask:0x008dffff
> /sys/bus/platform/devices/thinkpad_acpi/hotkey_report_mode:1
> /sys/bus/platform/devices/thinkpad_acpi/hotkey_source_mask:0x00000000

Well, the driver has connected to the firmware, and should be working.  And
there were no changes to the code from v3.0 to v3.1.1.  So, it is either a
bug in something else, a problematic interaction of the driver with
something else, or a latent thinkpad-acpi bug that some change elsewhere has
exposed.

Are the events reported by acpi_listen from arch-linux exactly the same in
v3.0.9 and v3.1.1 ?  I know some events are missing in your v3.1.1, but I am
interested in the ones that do get reported.

Although you really should be using the input device for the hotkeys, and
not any of the 0x10xx events.  Those are driver-specific and deprecated, it
is all explained in Documentation/laptops/thinkpad-acpi.txt.  So, it really
might mean that you have something in userspace reading that input device
and synthesizing the ACPI HKEY events thinkpad-acpi deprecated for a long
time now.  I know some distros did that instead of switching to an
input-device-based hotkey daemon.  Please check for that possibility,
that daemon could be the one having problems with 3.1.1...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
