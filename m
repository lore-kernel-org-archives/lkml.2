Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1KNBpC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 20:45:02 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43489 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab1KNBpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 20:45:00 -0500
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>
Cc: rt-users <linux-rt-users@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 1/2] v3.2-rc1-52e4c2a05-rt1 fix for compile break
Date: Mon, 14 Nov 2011 02:44:42 +0100
Message-Id: <1321235083-21756-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/rcutorture.c:492: error: ‘synchronize_rcu_bh’ undeclared here (not in a function)

In CONFIG_PREEMPT_RT_FULL
doesn't cover function pointer assignment unless we remove the brackets.

Compile-tested.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 include/linux/rcutree.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 800b840..6e503a3 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -60,7 +60,7 @@ static inline void exit_rcu(void)
 #ifndef CONFIG_PREEMPT_RT_FULL
 extern void synchronize_rcu_bh(void);
 #else
-# define synchronize_rcu_bh()	synchronize_rcu()
+# define synchronize_rcu_bh	synchronize_rcu
 #endif
 extern void synchronize_sched_expedited(void);
 extern void synchronize_rcu_expedited(void);
-- 
1.7.2.3

