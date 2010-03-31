Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab0CaCVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:21:18 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:57282 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab0CaCVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:21:15 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 33/33] x86: make e820 to be __initdata
Date: Tue, 30 Mar 2010 19:17:18 -0700
Message-Id: <1270001838-15857-34-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
References: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BB2B11E.00A3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally no users after init boot stage. We can free it to save some bytes.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/e820.h |    2 --
 arch/x86/kernel/e820.c      |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index cd7de51..f2ab72e 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -73,8 +73,6 @@ struct e820map {
 #define BIOS_END		0x00100000
 
 #ifdef __KERNEL__
-/* see comment in arch/x86/kernel/e820.c */
-extern struct e820map e820;
 
 #if defined(CONFIG_X86_OOSTORE) && defined(CONFIG_CPU_SUP_CENTAUR)
 extern int centaur_ram_top;
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 471784b..2c1260f 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -35,7 +35,7 @@
  * user can e.g. boot the original kernel with mem=1G while still booting the
  * next kernel with full memory.
  */
-struct e820map e820;
+static struct e820map __initdata e820;
 static struct e820map __initdata e820_saved;
 
 /* For PCI or other memory-mapped resources */
-- 
1.6.4.2

