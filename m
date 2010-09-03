Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0ICJEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:04:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:44090 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185Ab0ICJEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:04:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,312,1280732400"; 
   d="scan'208";a="834532601"
Date: Fri, 3 Sep 2010 17:04:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-ID: <20100903090407.GA19771@localhost>
References: <20100903121023.54c40e73.sfr@canb.auug.org.au>
 <20100903121201.336c4ba8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100903121201.336c4ba8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 10:12:01AM +0800, Stephen Rothwell wrote:
> On Fri, 3 Sep 2010 12:10:23 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> > produced this warning:
> > 
> > arch/x86/mm/init_64.c: In function 'kernel_physical_mapping_init':
> > arch/x86/mm/init_64.c:601: warning: 'addr' may be used uninitialized in this function
> > 
> > The code does look suspicious ... 'addr' gets declared and then passed to
> > a function, but is not set anywhere ...
> 
> Forgot to say:
> 
> Introduced by commit 9b861528a8012e7bc4d1f7bae07395b225331477 ("x86-64,
> mem: Update all PGDs for direct mapping and vmemmap mapping changes").


The original patch has the following line, however get lost some time
later:

        http://www.spinics.net/lists/linux-mm/msg08152.html

===
x86, mm: fix uninitialized addr in kernel_physical_mapping_init()

This re-adds the lost chunk in commit 9b861528a80.

CC: Haicheng Li <haicheng.li@linux.intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 64e7bc2..74f0f35 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -570,6 +570,7 @@ kernel_physical_mapping_init(unsigned long start,
 
 	start = (unsigned long)__va(start);
 	end = (unsigned long)__va(end);
+	addr = start;
 
 	for (; start < end; start = next) {
 		pgd_t *pgd = pgd_offset_k(start);
