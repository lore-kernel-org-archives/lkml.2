Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2LRHQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:16:26 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30213 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2LRHQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:16:24 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7 04/27] x86, realmode: use init_level4_pgt to set trapmoline_pgt directly
Date: Mon, 17 Dec 2012 23:15:36 -0800
Message-Id: <1355814959-10573-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with #PF handler way to set early page table, level3_ident will go away.

So just use entry in init_level4_pgt to set them

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/realmode/init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 0b7e840..815eec1 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -78,8 +78,8 @@ void __init setup_real_mode(void)
 	*trampoline_cr4_features = read_cr4();
 
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
-	trampoline_pgd[0] = __pa_symbol(level3_ident_pgt) + _KERNPG_TABLE;
-	trampoline_pgd[511] = __pa_symbol(level3_kernel_pgt) + _KERNPG_TABLE;
+	trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
+	trampoline_pgd[511] = init_level4_pgt[511].pgd;
 #endif
 }
 
-- 
1.7.10.4

