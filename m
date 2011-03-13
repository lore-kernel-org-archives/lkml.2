Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab1CMTvM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 15:51:12 -0400
Received: from mout.perfora.net ([74.208.4.194]:64806 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab1CMTvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 15:51:08 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Stephen Wilson <wilsons@start.ca>
Subject: [PATCH 01/12] x86: add context tag to mark mm when running a task in 32-bit compatibility mode
Date: Sun, 13 Mar 2011 15:49:13 -0400
Message-Id: <1300045764-24168-2-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1300045764-24168-1-git-send-email-wilsons@start.ca>
References: <1300045764-24168-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:HX4EvsWOCBaSE9bVOF4ZZALdyZLg6EZ6qTLXBlrcVxq
 7Vopnfa6Wr5fPl28E+ucG4dydV92lrS6lz/ukQDdOtibFoEf3X
 IcnI8eCV7+QvBQ5rzcAGrdJDa8ZDwOdw45Y5rNmy8nw6x9oN9G
 o6iFZaXfiV11coD52ujo7yEJqfuFVl+LPo2yTGDUv2tMVb8wX4
 q24xCtTt/YF8pxBK6xaCvSa+dx50s0B0Va1HzMwJJU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tag is intended to mirror the thread info TIF_IA32 flag.  Will be used to
identify mm's which support 32 bit tasks running in compatibility mode without
requiring a reference to the task itself.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Reviewed-by: Michel Lespinasse <walken@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/mmu.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index 80a1dee..aeff3e8 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -13,6 +13,12 @@ typedef struct {
 	int size;
 	struct mutex lock;
 	void *vdso;
+
+#ifdef CONFIG_X86_64
+	/* True if mm supports a task running in 32 bit compatibility mode. */
+	unsigned short ia32_compat;
+#endif
+
 } mm_context_t;
 
 #ifdef CONFIG_SMP
-- 
1.7.3.5

