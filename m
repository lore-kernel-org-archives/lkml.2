Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1EKPpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:45:52 -0400
Received: from mail4.comsite.net ([205.238.176.238]:48438 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab1EKPpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:45:50 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
To: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Message-Id: <37c48c3ec27da0d3378e652278a4700808ce913d.1305092637.git.miltonm@bga.com>
In-Reply-To: <cover.1305092637.git.miltonm@bga.com>
References: <cover.1305092637.git.miltonm@bga.com>
From: Milton Miller <miltonm@bga.com>
Date: Wed, 11 May 2011 00:29:13 -0500
Subject: [PATCH 12/37] linux/smp.h: remove unused MSG_ flags
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that powerpc has removed its use of MSG_ALL_BUT_SELF and MSG_ALL
all these MSG_ flags are unused.

Signed-off-by: Milton Miller <miltonm@bga.com>
---
To be merged by powerpc with the series posted to linuxppc-dev

After the previous 2 patches, grep shows the following false hits (from
partial symbol matches):

find . -name .git -prune -o -name .pc -prune -o -name patches -prune -o -type f|
 xargs grep -E 'MSG_(ALL|RESCHEDULE|CALL_FUNCTION|INVALIDATE_TLB|STOP_CPU)'

	XFRM_MSG_ALLOCSPI (include/linux/xfrm.h, net/xfrm/xfrm_user.c)
	CHANNELMSG_ALLOFFERS_DELIVERED (drivers/staging/hv/)
	PPC_MSG_CALL_FUNCTION, PPC_MSG_RESCHEDULE (arch/powerpc/)
	SMP_MSG_RESCHEDULE (arch/sh/)
---
 include/linux/smp.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 74243c8..7ad824d 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -98,16 +98,6 @@ void ipi_call_unlock_irq(void);
  */
 int on_each_cpu(smp_call_func_t func, void *info, int wait);
 
-#define MSG_ALL_BUT_SELF	0x8000	/* Assume <32768 CPU's */
-#define MSG_ALL			0x8001
-
-#define MSG_INVALIDATE_TLB	0x0001	/* Remote processor TLB invalidate */
-#define MSG_STOP_CPU		0x0002	/* Sent to shut down slave CPU's
-					 * when rebooting
-					 */
-#define MSG_RESCHEDULE		0x0003	/* Reschedule request from master CPU*/
-#define MSG_CALL_FUNCTION       0x0004  /* Call function on all other CPUs */
-
 /*
  * Mark the boot cpu "online" so that it can call console drivers in
  * printk() and can access its per-cpu storage.
-- 
1.7.0.4

