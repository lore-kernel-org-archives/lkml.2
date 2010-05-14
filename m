Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759742Ab0ENTw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:52:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17319 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab0ENTt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:49:57 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 37/37] x86: make e820 to be __initdata
Date: Fri, 14 May 2010 12:46:03 -0700
Message-Id: <1273866363-14249-38-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
References: <1273866363-14249-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4BEDA94B.012A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally no user after init boot stage. We can free it to save some bytes.

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
index c2e18f9..ad30efd 100644
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

