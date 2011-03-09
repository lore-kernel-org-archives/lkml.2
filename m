Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab1CIAdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:33:20 -0500
Received: from mout.perfora.net ([74.208.4.194]:50471 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986Ab1CIAdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:33:19 -0500
From: Stephen Wilson <wilsons@start.ca>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@linux.intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Stephen Wilson <wilsons@start.ca>
Subject: [PATCH 1/5] x86: add context tag to mark mm when running a task in 32-bit compatibility mode
Date: Tue,  8 Mar 2011 19:31:57 -0500
Message-Id: <1299630721-4337-2-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1299630721-4337-1-git-send-email-wilsons@start.ca>
References: <1299630721-4337-1-git-send-email-wilsons@start.ca>
X-Provags-ID: V02:K0:mo0tlu57qpz/hubSRoJ0vyz/3AdD7HQUol8/Smq4wqx
 8ZJbni67mQXAtjGPxVWoZUj6nsHvjZHjPr1cvnrp7rqBRudf9K
 5G9Peex8e1li/47KBi64MDgcOAch4/Bc3c0EY3wfHDRwCBwd1T
 mMP75y/pQT9kH/0ykuhsk6jaa6dGyR5ws6s3XIFegwVCo+K+YH
 +lLgZf+Z2AuHQOtyJ7H1reMRP/vv/Ggy7u2gISy4Ds=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tag is intended to mirror the thread info TIF_IA32 flag.  Will be used to
identify mm's which support 32 bit tasks running in compatibility mode without
requiring a reference to the task itself.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
---
 arch/x86/include/asm/mmu.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index 80a1dee..8a2e5b4 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -13,6 +13,12 @@ typedef struct {
 	int size;
 	struct mutex lock;
 	void *vdso;
+
+#ifdef CONFIG_X86_64
+	/* True if mm supports a task running in 32 bit compatibility mode. */
+	unsigned short compat;
+#endif
+
 } mm_context_t;
 
 #ifdef CONFIG_SMP
-- 
1.7.3.5

