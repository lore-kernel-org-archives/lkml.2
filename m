Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab0CUHQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 03:16:40 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:28715 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab0CUHPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 03:15:55 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/20] x86: make e820 to be initdata
Date: Sun, 21 Mar 2010 00:13:06 -0700
Message-Id: <1269155601-18247-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BA5C765.0043,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and we don't need to expose e820_any_mapped anymore

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/e820.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 40c04cf..a558609 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -34,7 +34,7 @@
  * user can e.g. boot the original kernel with mem=1G while still booting the
  * next kernel with full memory.
  */
-static struct e820map e820;
+static struct e820map __initdata e820;
 static struct e820map __initdata e820_saved;
 
 /* For PCI or other memory-mapped resources */
@@ -46,9 +46,10 @@ EXPORT_SYMBOL(pci_mem_start);
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
 
@@ -63,7 +64,6 @@ e820_any_mapped(u64 start, u64 end, unsigned type)
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(e820_any_mapped);
 
 /*
  * This function checks if the entire range <start,end> is mapped with type.
-- 
1.6.4.2

