Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab0EAAsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 20:48:24 -0400
Received: from mx7.orcon.net.nz ([219.88.242.57]:49370 "EHLO mx7.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab0EAAsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:48:23 -0400
X-Greylist: delayed 3128 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Apr 2010 20:48:22 EDT
From: Michael Cree <mcree@orcon.net.nz>
To: linux-kernel@vger.kernel.org
Cc: Michael Cree <mcree@orcon.net.nz>, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Tejun Heo <tj@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-alpha@vger.kernel.org
Subject: [PATCH 0/3] alpha: Implement Hardware Performance Events
Date: Sat,  1 May 2010 11:55:37 +1200
Message-Id: <cover.1272668360.git.mcree@orcon.net.nz>
X-Mailer: git-send-email 1.7.0
X-DSPAM-Check: by mx7.orcon.net.nz on Sat, 01 May 2010 11:56:13 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sat May  1 11:56:13 2010
X-DSPAM-Confidence: 0.9919
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches implement hardware performance events for the Alpha
EV67 and later CPUs.  I have had this running on a Compaq XP1000 (EV67,
single CPU) for a few days now.  Pretty cool -- discovered that the glibc
exp2() library routine uses on average 985 cycles to execute 777 CPU
instructions whereas Compaq's CPML library version of exp2() uses on average
32 cycles to execute 47 CPU instructions to achieve the same thing!

Michael Cree (3):
  alpha: Add performance monitor interrupt counter.
  alpha: Add wrperfmon.h header file to aid use of wrperfmon PALcall.
  alpha: Implement HW performance events on the EV67 and later CPUs.

 arch/alpha/include/asm/hw_irq.h     |    1 +
 arch/alpha/include/asm/perf_event.h |    8 +-
 arch/alpha/include/asm/wrperfmon.h  |   93 ++++
 arch/alpha/kernel/Makefile          |    1 +
 arch/alpha/kernel/irq.c             |    7 +-
 arch/alpha/kernel/irq_alpha.c       |    3 +
 arch/alpha/kernel/perf_event.c      |  836 +++++++++++++++++++++++++++++++++++
 7 files changed, 946 insertions(+), 3 deletions(-)
 create mode 100644 arch/alpha/include/asm/wrperfmon.h
 create mode 100644 arch/alpha/kernel/perf_event.c

