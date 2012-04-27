Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736Ab2D0Dlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 23:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759611Ab2D0Dlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 23:41:51 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Betty Dall <betty.dall@hp.com>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH] x86,nmi: Fix the type of nmiaction.flags field
Date: Thu, 26 Apr 2012 23:41:29 -0400
Message-Id: <1335498089-15792-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Betty Dall <betty.dall@hp.com>

This patch changes the type of the struct nmiaction flags field to
unsigned long from unsigned int. All the usages of the flags field
are unsigned long already. There is only one flag used currently,
NMI_FLAG_FIRST, but having the wrong size could cause a truncation
bug in the future on 64 bit architectures.

Signed-off-by: Betty Dall <betty.dall@hp.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/nmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 47acaf3..db071af 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -35,7 +35,7 @@
 struct nmiaction {
 	struct list_head list;
 	nmi_handler_t handler;
-	unsigned int flags;
+	unsigned long flags;
 	char *name;
 };
 
-- 
1.7.7.6

