Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab0JVCIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 22:08:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42891 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab0JVCIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 22:08:50 -0400
Date: Fri, 22 Oct 2010 13:08:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaohua Li <shaohua.li@intel.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20101022130843.710a21a0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
include/linux/percpu-defs.h between commit
c957ef2c59e952803766ddc22e89981ab534606f ("percpu: Introduce a
read-mostly percpu API") from Linus',  tree and commit
fe8e0c25cad28e8858ecfa5863333c70685a6811 ("x86, 32-bit: Align percpu area
and irq stacks to THREAD_SIZE") from the tip tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/percpu-defs.h
index 27ef6b1,ab20d11..0000000
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@@ -139,15 -139,18 +139,27 @@@
  	__aligned(PAGE_SIZE)
  
  /*
 + * Declaration/definition used for per-CPU variables that must be read mostly.
 + */
 +#define DECLARE_PER_CPU_READ_MOSTLY(type, name)			\
 +	DECLARE_PER_CPU_SECTION(type, name, "..readmostly")
 +
 +#define DEFINE_PER_CPU_READ_MOSTLY(type, name)				\
 +	DEFINE_PER_CPU_SECTION(type, name, "..readmostly")
 +
 +/*
+  * Declaration/definition used for large per-CPU variables that must be
+  * aligned to something larger than the pagesize.
+  */
+ #define DECLARE_PER_CPU_MULTIPAGE_ALIGNED(type, name, size)		\
+ 	DECLARE_PER_CPU_SECTION(type, name, "..page_aligned")		\
+ 	__aligned(size)
+ 
+ #define DEFINE_PER_CPU_MULTIPAGE_ALIGNED(type, name, size)		\
+ 	DEFINE_PER_CPU_SECTION(type, name, "..page_aligned")		\
+ 	__aligned(size)
+ 
+ /*
   * Intermodule exports for per-CPU variables.  sparse forgets about
   * address space across EXPORT_SYMBOL(), change EXPORT_SYMBOL() to
   * noop if __CHECKER__.
