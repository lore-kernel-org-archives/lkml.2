Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab2EXMbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 08:31:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39004 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab2EXMbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 08:31:22 -0400
Date: Thu, 24 May 2012 14:31:16 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Comrade DOS <suloevdmitry@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Performance drop
Message-ID: <20120524123116.GA4048@alberich.amd.com>
References: <CA+fU7qen=cwc1vMY1bv21_0GuNKXPQZXsQLVszYG1WG_r1XUGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+fU7qen=cwc1vMY1bv21_0GuNKXPQZXsQLVszYG1WG_r1XUGA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 02:12:39AM +0700, Comrade DOS wrote:
> PROBLEM: Performance drop
> 
> After the release of linux 3.4.0 I've updated the kernel on all my machines.
> In most of the computer upgrade was successful.
> However, on my old laptop (HP Compaq 6715b) after the upgrade was just
> impossible to work.
> I found that CPU frequency scaling no longer work properly on this machine.
> After loading the CPU clock is reset to the minimum (800 MHz), and
> remains so until you reboot.
> Changing the type of governor is not helping.
> Recompile the kernel without CPU frequency scaling has been to solve
> the problem, but even after this performance leaves much to be desired
> (although, according to /proc/cpuinfo CPU frequency set maximum).
> In addition to the above-described problems, there is another - the
> problem with rebooting and shutting down (and possibly also have a
> problem with s2ram and/or s2disk, but I'm their functionality I have
> not tested).
> If you try to shut down or restart the laptop it hangs.

This somehow reminds me of commit
26adcfbf00e0726b4469070aa2f530dcf963f484 (x86: SB600: skip ACPI IRQ0
override if it is not routed to INT2 of IOAPIC).

See also
https://bugzilla.kernel.org/show_bug.cgi?id=11715 and
https://bugzilla.kernel.org/show_bug.cgi?id=11516

Question is why the quirk doesn't work (anymore) on your system.

What was the kernel release used before 3.4.0 was install on your
Laptop?

Please provide dmesg with apic=debug kernel option when kernel 3.4 is
booted?

Can you please try to boot with kernel paramter
acpi_use_timer_override in another test run and with
acpi_skip_timer_override in a 3rd test (and also using acpi=debug in
both cases) and provide dmesg output for those testruns.


Thanks,

Andreas
