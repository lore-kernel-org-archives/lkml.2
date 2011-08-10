Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1HJBuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 21:50:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46080 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab1HJBuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 21:50:07 -0400
Date: Wed, 10 Aug 2011 11:49:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110810114956.238d66772883636e3040d29f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

arch/x86/kernel/cpu/amd.c: In function 'bsp_init_amd':
arch/x86/kernel/cpu/amd.c:437:3: error: 'va_align' undeclared (first use in this function)
arch/x86/kernel/cpu/amd.c:438:23: error: 'ALIGN_VA_32' undeclared (first use in this function)
arch/x86/kernel/cpu/amd.c:438:37: error: 'ALIGN_VA_64' undeclared (first use in this function)

Caused by the module.h split up intreacting with commit dfb09f9b7ab0
("x86, amd: Avoid cache aliasing penalties on AMD family 15h") from the
tip tree.

I have added the following patch for today (this, or something similar,
could be applied to the tip tree directly - the export.h include below
was added by the module.h splitup).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 10 Aug 2011 11:45:44 +1000
Subject: [PATCH] x86, amd: using va_align requires includeing elf.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kernel/cpu/amd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c17a8c4..a19a209 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -2,6 +2,7 @@
 #include <linux/bitops.h>
 #include <linux/export.h>
 #include <linux/mm.h>
+#include <linux/elf.h>
 
 #include <linux/io.h>
 #include <asm/processor.h>
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
