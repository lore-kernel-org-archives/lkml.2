Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab0IPHXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:23:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19912 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab0IPHXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:23:53 -0400
Message-ID: <4C91C544.5050907@kernel.org>
Date: Thu, 16 Sep 2010 00:20:36 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
References: <20100914002932.850d02f3.sfr@canb.auug.org.au>	<20100916163218.e09be473.sfr@canb.auug.org.au>	<20100916063922.GA17596@elte.hu> <20100916170939.22e38e4c.sfr@canb.auug.org.au>
In-Reply-To: <20100916170939.22e38e4c.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

[PATCH] arm,memblock: Fix compiling with sparsemem

Stephen Rothwell found:

> > > arch/arm/mm/init.c: In function 'arm_memory_present':
> > > arch/arm/mm/init.c:260: warning: ISO C90 forbids mixed declarations and code
> > > arch/arm/mm/init.c:338: error: invalid storage class for function 'free_area'
> > > arch/arm/mm/init.c:357: error: invalid storage class for function 'free_memmap'
> > > arch/arm/mm/init.c:386: error: invalid storage class for function 'free_unused_memmap'
> > > arch/arm/mm/init.c:601: error: invalid storage class for function 'keepinitrd_setup'
> > > arch/arm/mm/init.c:606: error: initializer element is not constant
> > > arch/arm/mm/init.c:606: error: (near initialization for '__setup_keepinitrd_setup.setup_func')
> > > arch/arm/mm/init.c:606: error: expected declaration or statement at end of input
> > > arch/arm/mm/init.c:252: warning: unused variable 'i'
> > >
> > > Caused by commit 719c1514f2fef5f01fcfa2bba81b7bb079c7c6a1 ("memblock/arm:
> > > Use new accessors") which forgot a closing brace on a new
> > > for_each_memblock() in arm_memory_present().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/arm/mm/init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/arch/arm/mm/init.c
===================================================================
--- linux-2.6.orig/arch/arm/mm/init.c
+++ linux-2.6/arch/arm/mm/init.c
@@ -249,9 +249,8 @@ static void arm_memory_present(void)
 static void arm_memory_present(void)
 {
 	struct memblock_region *reg;
-	int i;
 
-	for_each_memblock(memory, reg) {
+	for_each_memblock(memory, reg)
 		memory_present(0, memblock_region_base_pfn(reg),
 			       memblock_region_end_pfn(reg));
 }
