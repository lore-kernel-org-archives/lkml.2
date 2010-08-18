Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab0HRUzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 16:55:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:48234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab0HRUzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 16:55:47 -0400
Date: Wed, 18 Aug 2010 20:55:30 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joerg.roedel@amd.com, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <4C6C294D.3030404@zytor.com>
References: <4C6C294D.3030404@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32: Fix dummy trampoline-related inline stubs
Message-ID: <tip-8848a91068c018bc91f597038a0f41462a0f88a4@git.kernel.org>
Git-Commit-ID: 8848a91068c018bc91f597038a0f41462a0f88a4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 Aug 2010 20:55:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8848a91068c018bc91f597038a0f41462a0f88a4
Gitweb:     http://git.kernel.org/tip/8848a91068c018bc91f597038a0f41462a0f88a4
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Wed, 18 Aug 2010 11:42:23 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 18 Aug 2010 12:42:24 -0700

x86-32: Fix dummy trampoline-related inline stubs

Fix dummy inline stubs for trampoline-related functions when no
trampolines exist (until we get rid of the no-trampoline case
entirely.)

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <4C6C294D.3030404@zytor.com>
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
