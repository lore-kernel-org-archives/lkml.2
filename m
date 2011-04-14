Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab1DNSVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:21:11 -0400
Received: from mail.windriver.com ([147.11.1.11]:41409 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933659Ab1DNR5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:57:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 122/209] x86-32: Fix dummy trampoline-related inline stubs
Date: Thu, 14 Apr 2011 13:54:40 -0400
Message-Id: <1302803767-9715-9-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 8848a91068c018bc91f597038a0f41462a0f88a4 upstream.

Fix dummy inline stubs for trampoline-related functions when no
trampolines exist (until we get rid of the no-trampoline case
entirely.)

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <4C6C294D.3030404@zytor.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/trampoline.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/trampoline.h b/arch/x86/include/asm/trampoline.h
index 8f78fdf..4dde797 100644
--- a/arch/x86/include/asm/trampoline.h
+++ b/arch/x86/include/asm/trampoline.h
@@ -22,8 +22,8 @@ extern unsigned long setup_trampoline(void);
 extern void __init setup_trampoline_page_table(void);
 extern void __init reserve_trampoline_memory(void);
 #else
-static inline void reserve_trampoline_memory(void) {};
-extern void __init setup_trampoline_page_table(void) {};
+static inline void setup_trampoline_page_table(void) {}
+static inline void reserve_trampoline_memory(void) {}
 #endif /* CONFIG_X86_TRAMPOLINE */
 
 #endif /* __ASSEMBLY__ */
-- 
1.7.4.4

