Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1ERVZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:25:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41817 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab1ERVZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:25:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jD9uxAG+jg8Q7F8edDWm97nWbbci1ujBl1JMbsqrvzIV9bAiI9z+oBgUYez4IEjw6j
         RrLLPxVGNyQFwCglf40GHsGT5xfqtjX7yvc0Hdv70nrsK4q5jon7+iUKEHd3mJgSCtMH
         ZfHj7MGdhNntl00sTvi94JO1ux6tqZaPFc2BA=
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, bg-linux@lists.anl-external.org,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH 6/7] [RFC] enable early TLBs for BG/P
Date: Wed, 18 May 2011 16:24:54 -0500
Message-Id: <1305753895-24845-6-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BG/P maps firmware with an early TLB

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 arch/powerpc/include/asm/mmu-44x.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu-44x.h b/arch/powerpc/include/asm/mmu-44x.h
index ca1b90c..2807d6e 100644
--- a/arch/powerpc/include/asm/mmu-44x.h
+++ b/arch/powerpc/include/asm/mmu-44x.h
@@ -115,8 +115,12 @@ typedef struct {
 #endif /* !__ASSEMBLY__ */
 
 #ifndef CONFIG_PPC_EARLY_DEBUG_44x
+#ifndef CONFIG_BGP
 #define PPC44x_EARLY_TLBS	1
-#else
+#else /* CONFIG_BGP */
+#define PPC44x_EARLY_TLBS	2
+#endif /* CONFIG_BGP */
+#else /* CONFIG_PPC_EARLY_DEBUG_44x */
 #define PPC44x_EARLY_TLBS	2
 #define PPC44x_EARLY_DEBUG_VIRTADDR	(ASM_CONST(0xf0000000) \
 	| (ASM_CONST(CONFIG_PPC_EARLY_DEBUG_44x_PHYSLOW) & 0xffff))
-- 
1.7.4.1

