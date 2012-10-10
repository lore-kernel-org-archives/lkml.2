Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab2JJXsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:48:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54468 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab2JJXsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:48:36 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paul.mckenney@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] rcu: Advise most users not to enable RCU user mode
Date: Thu, 11 Oct 2012 01:48:28 +0200
Message-Id: <1349912908-11814-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discourage distros from enabling CONFIG_RCU_USER_QS
because it brings overhead for no benefits yet.

It's not a useful feature on its own until we can
fully run an adaptive tickless kernel.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 init/Kconfig |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index c26b8a1..89093e1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -451,6 +451,12 @@ config RCU_USER_QS
 	  excluded from the global RCU state machine and thus doesn't
 	  to keep the timer tick on for RCU.
 
+	  Unless you want to hack and help the development of the full
+	  tickless feature, you shouldn't enable this option. It adds
+	  unnecessary overhead.
+
+	  If unsure say N
+
 config RCU_USER_QS_FORCE
 	bool "Force userspace extended QS by default"
 	depends on RCU_USER_QS
@@ -459,6 +465,12 @@ config RCU_USER_QS_FORCE
 	  test this feature that treats userspace as an extended quiescent
 	  state until we have a real user like a full adaptive nohz option.
 
+	  Unless you want to hack and help the development of the full
+	  tickless feature, you shouldn't enable this option. It adds
+	  unnecessary overhead.
+
+	  If unsure say N
+
 config RCU_FANOUT
 	int "Tree-based hierarchical RCU fanout value"
 	range 2 64 if 64BIT
-- 
1.7.5.4

