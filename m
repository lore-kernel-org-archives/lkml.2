Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab0DIGJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 02:09:28 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:28597 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab0DIGJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 02:09:23 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 33/39] x86: Change e820_any_mapped() to __init
Date: Thu,  8 Apr 2010 23:04:02 -0700
Message-Id: <1270793048-23796-34-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BBEC45E.003F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to expose e820_any_mapped() anymore

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/e820.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index be6e1e6..471784b 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -47,9 +47,10 @@ EXPORT_SYMBOL(pci_mem_start);
 /*
  * This function checks if any part of the range <start,end> is mapped
  * with type.
+ * phys_pud_init() is using it and is _meminit, but we have !after_bootmem
+ * so could use refok here
  */
-int
-e820_any_mapped(u64 start, u64 end, unsigned type)
+int __init_refok e820_any_mapped(u64 start, u64 end, unsigned type)
 {
 	int i;
 
@@ -64,7 +65,6 @@ e820_any_mapped(u64 start, u64 end, unsigned type)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(e820_any_mapped);
 
 /*
  * This function checks if the entire range <start,end> is mapped with type.
-- 
1.6.4.2

