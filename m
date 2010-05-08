Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab0EHPVK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:21:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63680 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab0EHPUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:20:24 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/22] lmb: Move lmb.c to mm/
Date: Sat,  8 May 2010 08:17:19 -0700
Message-Id: <1273331860-14325-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090209.4BE580FB.0066,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lmb.c is memory related, so move it to mm/. It is suggested by Ingo

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 lib/Makefile      |    2 --
 mm/Makefile       |    2 ++
 {lib => mm}/lmb.c |    0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename {lib => mm}/lmb.c (100%)

diff --git a/lib/Makefile b/lib/Makefile
index 9e6d3c2..a8f7d48 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -88,8 +88,6 @@ obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
-obj-$(CONFIG_HAVE_LMB) += lmb.o
-
 obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
 
 obj-$(CONFIG_DYNAMIC_DEBUG) += dynamic_debug.o
diff --git a/mm/Makefile b/mm/Makefile
index 6c2a73a..52492f9 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -15,6 +15,8 @@ obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   $(mmu-y)
 obj-y += init-mm.o
 
+obj-$(CONFIG_HAVE_LMB) += lmb.o
+
 obj-$(CONFIG_BOUNCE)	+= bounce.o
 obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
diff --git a/lib/lmb.c b/mm/lmb.c
similarity index 100%
rename from lib/lmb.c
rename to mm/lmb.c
-- 
1.6.4.2

