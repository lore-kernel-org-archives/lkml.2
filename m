Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2FYMBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 08:01:33 -0400
Received: from linux-sh.org ([111.68.239.195]:36685 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab2FYMBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 08:01:32 -0400
Date: Mon, 25 Jun 2012 21:00:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] bug.h: Fix up x86 build regression
Message-ID: <20120625120052.GE24033@linux-sh.org>
References: <20120618045417.GB19803@linux-sh.org>
 <20120625094215.GA25847@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625094215.GA25847@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 11:42:15AM +0200, Ingo Molnar wrote:
> 
> * Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > The asm-generic/bug.h __ASSEMBLY__ guarding is completely bogus, which
> > tripped up the powerpc build when the kernel.h include was added:
> > 
> > 	In file included from include/asm-generic/bug.h:5:0,
> > 			 from arch/powerpc/include/asm/bug.h:127,
> > 			 from arch/powerpc/kernel/head_64.S:31:
> > 	include/linux/kernel.h:44:0: warning: "ALIGN" redefined [enabled by default]
> > 	include/linux/linkage.h:57:0: note: this is the location of the previous definition
> > 	include/linux/sysinfo.h: Assembler messages:
> > 	include/linux/sysinfo.h:7: Error: Unrecognized opcode: `struct'
> > 	include/linux/sysinfo.h:8: Error: Unrecognized opcode: `__kernel_long_t'
> > 
> > Moving the __ASSEMBLY__ guard up and stashing the kernel.h include under
> > it fixes this up, as well as covering the case the original fix was
> > attempting to handle.
> > 
> > Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> This commit broke most x86 !CONFIG_BUG builds in -rc4:
> 
Yes, that was reported already and I've sent out a fix:

https://lkml.org/lkml/2012/6/25/98
