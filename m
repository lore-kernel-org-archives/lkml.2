Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab1EIN1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 09:27:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39347 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1EIN1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 09:27:52 -0400
Date: Mon, 9 May 2011 14:27:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 0/4] Consolidate i8253 clocksource
Message-ID: <20110509132738.GB16919@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three architectures have an i8253 PIT clocksource, and each duplicates
the code for this.  The initial patch extracts a common implementation
to drivers/clocksource, and subsequent patches convert each architecture
to use this copy.

 arch/arm/include/asm/i8253.h         |   15 ++++++
 arch/arm/mach-footbridge/Kconfig     |    2 +
 arch/arm/mach-footbridge/isa-timer.c |   45 ++----------------
 arch/mips/Kconfig                    |    1 +
 arch/mips/include/asm/i8253.h        |    5 ++
 arch/mips/kernel/i8253.c             |   78 +-----------------------------
 arch/x86/Kconfig                     |    1 +
 arch/x86/include/asm/i8253.h         |    2 +
 arch/x86/kernel/i8253.c              |   79 +------------------------------
 drivers/clocksource/Kconfig          |    3 +
 drivers/clocksource/Makefile         |    1 +
 drivers/clocksource/i8253.c          |   88 ++++++++++++++++++++++++++++++++++
 include/linux/clocksource.h          |    2 +
 13 files changed, 126 insertions(+), 196 deletions(-)

