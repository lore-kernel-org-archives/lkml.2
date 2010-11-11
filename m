Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab0KKPO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 10:14:26 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:35649 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab0KKPOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:14:24 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3extmailp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LBQ7NK-02-G7P-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Greg KH <greg@kroah.com>
CC: Borislav Petkov <bp@amd64.org>, <linux-kernel@vger.kernel.org>,
        <stable@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/3] x86-32: Fix dummy trampoline-related inline stubs
Date: Thu, 11 Nov 2010 16:16:16 +0100
Message-ID: <1289488576-18117-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20101111141358.GA4641@kroah.com>
References: <20101111141358.GA4641@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

commit 8848a91068c018bc91f597038a0f41462a0f88a4 upstream

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
index 2ab4ccd..ebace68 100644
--- a/arch/x86/include/asm/trampoline.h
+++ b/arch/x86/include/asm/trampoline.h
@@ -23,8 +23,8 @@ extern unsigned long setup_trampoline(void);
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
1.7.0.4


