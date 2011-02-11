Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1BKAA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:00:58 -0500
Received: from www.tglx.de ([62.245.132.106]:36639 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757366Ab1BKAA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:00:56 -0500
Date: Fri, 11 Feb 2011 01:00:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 00/75] genirq: Overhaul for 2.6.39
In-Reply-To: <AANLkTi=waRQcvdxyKUgcLZ1r-hwUcAVZeVDcBa-apyK2@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1102110058450.31804@localhost6.localdomain6>
References: <20110210222908.661199947@linutronix.de> <AANLkTi=waRQcvdxyKUgcLZ1r-hwUcAVZeVDcBa-apyK2@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011, Linus Torvalds wrote:

> On Thu, Feb 10, 2011 at 3:35 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > A preview is available at:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-genirq.git irq/core
> 
> For things like this, please just always include a diffstat so that
> people can tell from the email whether they care or not.

Oops. Forgot.

 arch/arm/mach-ep93xx/gpio.c         |   38 ---
 arch/arm/mach-ns9xxx/irq.c          |   58 -----
 arch/arm/mach-tegra/gpio.c          |   63 ------
 arch/arm/mach-tegra/irq.c           |   58 -----
 arch/m68knommu/platform/5272/intc.c |    7 
 arch/x86/Kconfig                    |    3 
 arch/x86/kernel/apic/io_apic.c      |   55 ++---
 arch/x86/kernel/hpet.c              |    2 
 arch/x86/kernel/irq.c               |   63 ------
 drivers/gpio/gpiolib.c              |   44 ----
 fs/proc/interrupts.c                |    2 
 include/linux/interrupt.h           |   22 --
 include/linux/irq.h                 |  314 ++++++++++++++++++++++++++------
 include/linux/irqdesc.h             |   68 ++++++
 kernel/irq/Kconfig                  |   10 -
 kernel/irq/autoprobe.c              |   48 ++--
 kernel/irq/chip.c                   |  353 +++++++++++++++++-------------------
 kernel/irq/compat.h                 |   72 +++++++
 kernel/irq/debug.h                  |   40 ++++
 kernel/irq/handle.c                 |   55 ++++-
 kernel/irq/internals.h              |  136 +++++++++----
 kernel/irq/irqdesc.c                |    6 
 kernel/irq/manage.c                 |  303 ++++++++++++++++++------------
 kernel/irq/migration.c              |   38 ++-
 kernel/irq/pm.c                     |    9 
 kernel/irq/proc.c                   |   73 +++++++
 kernel/irq/resend.c                 |   17 -
 kernel/irq/settings.h               |  131 +++++++++++++
 kernel/irq/spurious.c               |  164 ++++++++++------
 29 files changed, 1353 insertions(+), 899 deletions(-)
