Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab1JKQPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 12:15:42 -0400
Received: from shutemov.name ([188.40.19.243]:38154 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab1JKQPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 12:15:40 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, lennart@poettering.net,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH, v10 2/3] hrtimer: implement PR_GET_EFFECTIVE_TIMERSLACK
Date: Tue, 11 Oct 2011 19:15:28 +0300
Message-Id: <1318349729-3108-3-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.5
In-Reply-To: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill@shutemov.name>

PR_GET_EFFECTIVE_TIMERSLACK allows process to know its effective timer
slack value.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 include/linux/prctl.h |    6 ++++++
 kernel/sys.c          |    3 +++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..3199458 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,10 @@
 
 #define PR_MCE_KILL_GET 34
 
+/*
+ * Get effective timerslack value for the process.
+ * It can be higher than PR_GET_TIMERSLACK.
+ */
+#define PR_GET_EFFECTIVE_TIMERSLACK 35
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 6fecef0..4b86e41 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1798,6 +1798,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		case PR_GET_TIMERSLACK:
 			error = current->timer_slack_ns;
 			break;
+		case PR_GET_EFFECTIVE_TIMERSLACK:
+			error = task_get_effective_timer_slack(current);
+			break;
 		case PR_SET_TIMERSLACK:
 			if (arg2 <= 0)
 				current->timer_slack_ns =
-- 
1.7.6.3

