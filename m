Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2EGR7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:59:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:41374 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab2EGR7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:59:48 -0400
Message-Id: <20120507175450.513667947@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 07 May 2012 17:59:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 0/8] cpuidle: Fix and replace cpu_idle_wait copied code
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_idle_wait() is available in several identical copies all over
arch/ plus a broken variant.

This series fixes the broken one first and then replaces all the
identical ones with a generic version.

Thanks,

	tglx
----
 arch/arm/Kconfig                     |    3 ---
 arch/arm/include/asm/processor.h     |    2 --
 arch/arm/kernel/process.c            |   20 --------------------
 arch/ia64/include/asm/processor.h    |    1 -
 arch/ia64/kernel/process.c           |   20 --------------------
 arch/powerpc/Kconfig                 |    4 ----
 arch/powerpc/include/asm/processor.h |    1 -
 arch/powerpc/kernel/idle.c           |   23 -----------------------
 arch/sh/Kconfig                      |    3 ---
 arch/sh/include/asm/processor.h      |    1 -
 arch/sh/kernel/idle.c                |   20 --------------------
 arch/x86/Kconfig                     |    3 ---
 arch/x86/include/asm/processor.h     |    2 --
 arch/x86/kernel/apm_32.c             |    2 +-
 arch/x86/kernel/process.c            |   20 --------------------
 drivers/cpuidle/cpuidle.c            |   13 +------------
 include/linux/smp.h                  |    4 ++++
 kernel/smp.c                         |   23 +++++++++++++++++++++++
 18 files changed, 29 insertions(+), 136 deletions(-)

