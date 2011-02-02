Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab1BBV6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:58:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:50513 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab1BBV6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:58:31 -0500
Date: Wed, 2 Feb 2011 21:58:16 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <20110201134418.326209775@linutronix.de>
References: <20110201134418.326209775@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] thread_info: Remove legacy arg0-3 from restart_block
Message-ID: <tip-d608c18203a969e5d14572a9861c646d0bb66872@git.kernel.org>
Git-Commit-ID: d608c18203a969e5d14572a9861c646d0bb66872
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 21:58:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d608c18203a969e5d14572a9861c646d0bb66872
Gitweb:     http://git.kernel.org/tip/d608c18203a969e5d14572a9861c646d0bb66872
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 1 Feb 2011 13:51:43 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:13 +0100

thread_info: Remove legacy arg0-3 from restart_block

posix timers were the last users of the legacy arg0-3 members of
restart_block. Remove the cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
LKML-Reference: <20110201134418.326209775@linutronix.de>
---
 include/linux/thread_info.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index c906965..20fc303 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -18,9 +18,6 @@ struct compat_timespec;
 struct restart_block {
 	long (*fn)(struct restart_block *);
 	union {
-		struct {
-			unsigned long arg0, arg1, arg2, arg3;
-		};
 		/* For futex_wait and futex_wait_requeue_pi */
 		struct {
 			u32 __user *uaddr;
