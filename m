Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab0EMHQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 03:16:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:54260 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377Ab0EMHQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 03:16:10 -0400
Date: Thu, 13 May 2010 07:15:39 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, gorcunov@gmail.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, gorcunov@gmail.com, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
In-Reply-To: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
References: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] x86, watchdog: Fix build error in hw_nmi.c
Message-ID: <tip-5e85391b3badd3f0e50ebdd0cafe0202a979f73a@git.kernel.org>
Git-Commit-ID: 5e85391b3badd3f0e50ebdd0cafe0202a979f73a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 07:15:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e85391b3badd3f0e50ebdd0cafe0202a979f73a
Gitweb:     http://git.kernel.org/tip/5e85391b3badd3f0e50ebdd0cafe0202a979f73a
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 13 May 2010 09:12:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 13 May 2010 09:12:39 +0200

x86, watchdog: Fix build error in hw_nmi.c

On some configs the following build error triggers:

 arch/x86/kernel/apic/hw_nmi.c:35: error: 'apic' undeclared (first use in this function)
 arch/x86/kernel/apic/hw_nmi.c:35: error: (Each undeclared identifier is reported only once
 arch/x86/kernel/apic/hw_nmi.c:35: error: for each function it appears in.)

Because asm/apic.h was only included implicitly. Include it explicitly.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
LKML-Reference: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/hw_nmi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 3b40082..cefd694 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -8,6 +8,7 @@
  *  Bits copied from original nmi.c file
  *
  */
+#include <asm/apic.h>
 
 #include <linux/cpumask.h>
 #include <linux/kdebug.h>
