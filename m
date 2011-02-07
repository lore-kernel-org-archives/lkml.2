Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1BGXwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:52:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25221 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab1BGXwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:52:22 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/11] x86: Change get_max_mapped() to inline
Date: Mon,  7 Feb 2011 15:17:06 -0800
Message-Id: <1297120632-24933-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
References: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D508582.00C2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move it into head file. to prepare use it in other files.

-v2: hpa pointed out that u64 should not be used here.
     Actually We could unsigned long here. because for 32bit it will under 4g.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/page_types.h |    5 +++++
 arch/x86/kernel/setup.c           |    9 ---------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 1df6621..cf271fd 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -45,6 +45,11 @@ extern int devmem_is_allowed(unsigned long pagenr);
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
+static inline unsigned long get_max_mapped(void)
+{
+	return max_pfn_mapped<<PAGE_SHIFT;
+}
+
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d3cfe26..23a7a5f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -680,15 +680,6 @@ static int __init parse_reservelow(char *p)
 
 early_param("reservelow", parse_reservelow);
 
-static u64 __init get_max_mapped(void)
-{
-	u64 end = max_pfn_mapped;
-
-	end <<= PAGE_SHIFT;
-
-	return end;
-}
-
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
-- 
1.7.1

