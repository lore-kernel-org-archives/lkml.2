Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3AGB0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:26:17 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47152 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab3AGB0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:26:15 -0500
Date: Sun, 6 Jan 2013 17:22:43 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH resend 0/3] ARM: KDB FIQ debugger
Message-ID: <20130107012242.GA31052@lizard.mcd01528.sjc.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew, Russell,

Just resending this once again...

(Also rebased onto v3.8-rc2, and since there were some irqdomain changes,
I had to drop VIC changes from the series, and place the IRQ rerouting
code into the board code. But that is even better, so far we don't need it
anywhere else.)

Short description of the KDB/FIQ debugger:

 The FIQ debugger is a facility that can be used to debug situations when
 the kernel stuck in uninterruptable sections, e.g. the kernel infinitely
 loops or deadlocked in an interrupt or with interrupts disabled. On some
 development boards there is even a special NMI button, which is very
 useful for debugging weird kernel hangs.

 And FIQ is basically an NMI, it has a higher priority than IRQs, and upon
 IRQ exception FIQs are not disabled. It is still possible to disable FIQs
 (as well as some "NMIs" on other architectures), but via special means.

Old changelogs and a full rationale for these patches can be found here:

	v1-v5, rationale: http://lkml.org/lkml/2012/9/10/2
	v6: http://lkml.org/lkml/2012/9/10/2
	v7: http://lkml.org/lkml/2012/9/13/367
	v8: http://lkml.org/lkml/2012/9/19/525
	v9: http://lkml.org/lkml/2012/9/24/538

Thanks!
Anton

--
 arch/arm/Kconfig                   |  19 ++++
 arch/arm/include/asm/kgdb.h        |   7 ++
 arch/arm/kernel/Makefile           |   1 +
 arch/arm/kernel/entry-armv.S       | 167 +---------------------------
 arch/arm/kernel/entry-header.S     | 170 +++++++++++++++++++++++++++++
 arch/arm/kernel/kgdb_fiq.c         | 118 ++++++++++++++++++++
 arch/arm/kernel/kgdb_fiq_entry.S   |  87 +++++++++++++++
 arch/arm/mach-versatile/Makefile   |   1 +
 arch/arm/mach-versatile/kgdb_fiq.c |  55 ++++++++++
 9 files changed, 459 insertions(+), 166 deletions(-)
