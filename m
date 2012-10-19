Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab2JSVhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:37:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37032 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2JSVhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:37:36 -0400
Date: Fri, 19 Oct 2012 23:37:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (tip/s390 trees related)
Message-ID: <20121019213727.GA9630@gmail.com>
References: <20121018172201.b81dcc8fe40868256f532364@canb.auug.org.au>
 <20121018182642.2a541275@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018182642.2a541275@thinkpad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:

> On Thu, 18 Oct 2012 17:22:01 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi all,
> > 
> > After merging the final tree, today's linux-next build (s390 allyesconfig)
> > failed like this:
> > 
> > mm/huge_memory.c:1424:2: error: implicit declaration of function 'pmd_pgprot' [-Werror=implicit-function-declaration]
> > mm/huge_memory.c:1424:7: error: incompatible types when assigning to type 'pgprot_t' from type 'int'
> > 
> > (see http://kisskb.ellerman.id.au/kisskb/buildresult/7383823/)
> > 
> > Caused by commit 35d3d3427314 ("s390/thp: select
> > HAVE_ARCH_TRANSPARENT_HUGEPAGE") from the s390 tree interacting with
> > commit 93c9d633bd9e ("mm/thp: Preserve pgprot across huge page split")
> > from the tip tree.
> > 
> > N.B. Mips also selects HAVE_ARCH_TRANSPARENT_HUGEPAGE as of commit
> > e21a828a1bba ("MIPS: Transparent Huge Pages support") from the mips tree
> > and so will be broken in some configs now as well.
> > 
> > Anyone have suggested merge fix patches I can apply?
> 
> Subject: [PATCH] s390/thp: implement pmd_pgprot() for s390

Thanks Gerald! I'll merge this as well so that the semantic 
conflict disappears from linux-next.

Thanks,

	Ingo
