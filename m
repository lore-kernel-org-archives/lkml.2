Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab2KSF33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:29:29 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45834 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab2KSF30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:26 -0500
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/58] linux/irq_work.h: Add prototype for arch_irq_work_raise
Date: Sun, 18 Nov 2012 21:27:51 -0800
Message-Id: <1353302917-13995-13-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several architectures define arch_irq_work_raise, and kernel/irq_work.c
defines a __weak version for architectures that do not.  However,
nothing ever prototypes this function, leading to warnings from GCC and
Sparse like this:

kernel/irq_work.c:52:28: warning: no previous prototype for ‘arch_irq_work_raise’ [-Wmissing-prototypes]

Add a prototype for this function in linux/irq_work.h.  In addition to
eliminating the warnings, this also ensures that the types for all
versions of the function will stay in sync.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/irq_work.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6a9e8f5..c23821e 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -20,4 +20,6 @@ bool irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
 
+void arch_irq_work_raise(void);
+
 #endif /* _LINUX_IRQ_WORK_H */
-- 
1.7.10.4

