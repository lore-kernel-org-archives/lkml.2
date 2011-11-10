Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107Ab1KJJmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 04:42:18 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47598 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934054Ab1KJJmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 04:42:14 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] kernel.h: Neaten panic prototype
Date: Thu, 10 Nov 2011 01:41:42 -0800
Message-Id: <229cd6132a1ad2707545a2b1de9435e90cf97d9d.1320917556.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1320917551.git.joe@perches.com>
References: <cover.1320917551.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __printf macro.
Convert NORET_AND to ATTRIB_NORET.
Use the normal kernel style for pointer arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e8b1597..23dae61 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -185,8 +185,9 @@ static inline void might_fault(void)
 
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(int state);
-NORET_TYPE void panic(const char * fmt, ...)
-	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
+NORET_TYPE __printf(1, 2)
+void panic(const char *fmt, ...)
+	ATTRIB_NORET __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
 void print_oops_end_marker(void);
-- 
1.7.6.405.gc1be0

