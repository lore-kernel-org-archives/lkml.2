Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab2JVRCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:02:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40635 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755710Ab2JVRB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:01:58 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Pekka Enberg <penberg@kernel.org>,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] rbtree: include linux/compiler.h for definition of __always_inline
Date: Mon, 22 Oct 2012 18:01:27 +0100
Message-Id: <1350925287-15929-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rb_erase_augmented is a static function annotated with __always_inline.
This causes a compile failure when attempting to use the rbtree
implementation as a library (e.g. kvm tool):

rbtree_augmented.h:125:24: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘void’

This patch includes linux/compiler.h in rbtree_augmented.h so that the
__always_inline macro is resolved correctly.

Cc: Pekka Enberg <penberg@kernel.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 include/linux/rbtree_augmented.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
index 214caa3..2ac60c9 100644
--- a/include/linux/rbtree_augmented.h
+++ b/include/linux/rbtree_augmented.h
@@ -24,6 +24,7 @@
 #ifndef _LINUX_RBTREE_AUGMENTED_H
 #define _LINUX_RBTREE_AUGMENTED_H
 
+#include <linux/compiler.h>
 #include <linux/rbtree.h>
 
 /*
-- 
1.7.4.1

