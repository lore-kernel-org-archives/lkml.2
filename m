Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab0C3Lat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 07:30:49 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:29911 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab0C3Laq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 07:30:46 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/29] lmb: Move lmb.c to mm/
Date: Tue, 30 Mar 2010 04:19:36 -0700
Message-Id: <1269948003-17221-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269948003-17221-1-git-send-email-yinghai@kernel.org>
References: <1269948003-17221-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0202.4BB1DEC6.0237,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lmb.c is memory related, so move it to mm/ according to Ingo

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 lib/Makefile      |    2 --
 mm/Makefile       |    2 ++
 {lib => mm}/lmb.c |    0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename {lib => mm}/lmb.c (100%)

diff --git a/lib/Makefile b/lib/Makefile
index 2e152ae..a463a4d 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -85,8 +85,6 @@ obj-$(CONFIG_FAULT_INJECTION) += fault-inject.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
-obj-$(CONFIG_HAVE_LMB) += lmb.o
-
 obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
 
 obj-$(CONFIG_DYNAMIC_DEBUG) += dynamic_debug.o
diff --git a/mm/Makefile b/mm/Makefile
index 7a68d2a..df22fd1 100644
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

