Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab1GTTLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:11:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45329 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1GTTLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:11:00 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Wed, 20 Jul 2011 21:10:43 +0200
Message-Id: <1311189043-23175-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <alpine.LFD.2.02.1107200153070.2702@ionos>
References: <alpine.LFD.2.02.1107200153070.2702@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] Fix build failure for modular ext3/4 builds
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Followup for fs-jbd-replace-bh_state-lock.patch

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 include/linux/buffer_head.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 7283b77..d839fba 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -74,7 +74,8 @@ struct buffer_head {
 	atomic_t b_count;		/* users using this buffer_head */
 #ifdef CONFIG_PREEMPT_RT_BASE
 	spinlock_t b_uptodate_lock;
-#if defined(CONFIG_JBD) || defined(CONFIG_JBD2)
+#if defined(CONFIG_JBD) || defined(CONFIG_JBD_MODULE) || \
+	defined(CONFIG_JBD2) || defined(CONFIG_JBD2_MODULE)
 	spinlock_t b_state_lock;
 	spinlock_t b_journal_head_lock;
 #endif
-- 
1.7.5.4

