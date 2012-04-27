Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389Ab2D0UlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:41:24 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:45713 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760239Ab2D0UlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:41:23 -0400
From: Betty Dall <betty.dall@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org,
        Betty Dall <betty.dall@hp.com>
Subject: [PATCH v2] x86,nmi: Fix the type of nmiaction.flags field
Date: Fri, 27 Apr 2012 14:40:55 -0600
Message-Id: <1335559255-13454-1-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the type of the struct nmiaction flags field to
unsigned long from unsigned int. All the usages of the flags field
are unsigned long already. There is only one flag used currently,
NMI_FLAG_FIRST, but having the wrong size could cause a truncation
bug in the future on 64 bit architectures.

v1->v2: The structure moved from nmi.c to nmi.h in the tip git tree
so I am anticipating a merge conflict with the first patch sent by
Don Zickus.

Signed-off-by: Betty Dall <betty.dall@hp.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index a1a836c..0e3793b 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -40,7 +40,7 @@ typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
 struct nmiaction {
 	struct list_head	list;
 	nmi_handler_t		handler;
-	unsigned int		flags;
+	unsigned long		flags;
 	const char		*name;
 };
 
-- 
1.7.5.4

