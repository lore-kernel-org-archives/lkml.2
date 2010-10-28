Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab0J1KB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 06:01:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:34617 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab0J1KB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 06:01:26 -0400
Date: Thu, 28 Oct 2010 10:01:06 GMT
From: tip-bot for Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        lethal@linux-sh.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, lethal@linux-sh.org
In-Reply-To: <20101028023031.GB10365@linux-sh.org>
References: <20101028023031.GB10365@linux-sh.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Fix up irq_node() for irq_data changes.
Message-ID: <tip-4600d7c493f354a3e338a35bcf8a3bfbe815776a@git.kernel.org>
Git-Commit-ID: 4600d7c493f354a3e338a35bcf8a3bfbe815776a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 28 Oct 2010 10:01:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4600d7c493f354a3e338a35bcf8a3bfbe815776a
Gitweb:     http://git.kernel.org/tip/4600d7c493f354a3e338a35bcf8a3bfbe815776a
Author:     Paul Mundt <lethal@linux-sh.org>
AuthorDate: Thu, 28 Oct 2010 11:30:31 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 28 Oct 2010 11:58:39 +0200

genirq: Fix up irq_node() for irq_data changes.

Now that the node ID is tracked in the irq_data structure, update the
irq_node() definition accordingly. This fixes up irq_node() usage under
GENERIC_HARDIRQS_NO_DEPRECATED && SMP.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
LKML-Reference: <20101028023031.GB10365@linux-sh.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/irqnr.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/irqnr.h b/include/linux/irqnr.h
index 05aa8c23..3bc4dca 100644
--- a/include/linux/irqnr.h
+++ b/include/linux/irqnr.h
@@ -43,7 +43,7 @@ unsigned int irq_get_next_irq(unsigned int offset);
 		else
 
 #ifdef CONFIG_SMP
-#define irq_node(irq)	(irq_to_desc(irq)->node)
+#define irq_node(irq)	(irq_get_irq_data(irq)->node)
 #else
 #define irq_node(irq)	0
 #endif
