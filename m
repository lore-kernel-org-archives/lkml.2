Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab0IPGjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:39:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49581 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab0IPGjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:39:43 -0400
Date: Thu, 16 Sep 2010 08:39:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
Message-ID: <20100916063922.GA17596@elte.hu>
References: <20100914002932.850d02f3.sfr@canb.auug.org.au>
 <20100916163218.e09be473.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916163218.e09be473.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> On Tue, 14 Sep 2010 00:29:32 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the final tree, today's linux-next build (arm
> > assabet_defconfig and serveral other arm configs) failed like this:
> > 
> > arch/arm/mm/init.c: In function 'arm_memory_present':
> > arch/arm/mm/init.c:260: warning: ISO C90 forbids mixed declarations and code
> > arch/arm/mm/init.c:338: error: invalid storage class for function 'free_area'
> > arch/arm/mm/init.c:357: error: invalid storage class for function 'free_memmap'
> > arch/arm/mm/init.c:386: error: invalid storage class for function 'free_unused_memmap'
> > arch/arm/mm/init.c:601: error: invalid storage class for function 'keepinitrd_setup'
> > arch/arm/mm/init.c:606: error: initializer element is not constant
> > arch/arm/mm/init.c:606: error: (near initialization for '__setup_keepinitrd_setup.setup_func')
> > arch/arm/mm/init.c:606: error: expected declaration or statement at end of input
> > arch/arm/mm/init.c:252: warning: unused variable 'i'
> > 
> > Caused by commit 719c1514f2fef5f01fcfa2bba81b7bb079c7c6a1 ("memblock/arm:
> > Use new accessors") which forgot a closing brace on a new
> > for_each_memblock() in arm_memory_present().
> 
> So this commit is back in tip and the error is back in the builds ...

The ARM defconfig build doesnt fail here:

  WARNING: modpost: Found 5 section mismatch(es).
  To see full details build your kernel with:
  'make CONFIG_DEBUG_SECTION_MISMATCH=y'

Is there some integration artifact here perhaps? If yes then linux-next 
needs to resolve the integration artifact. If not then benh, Yinghai, 
hpa, please have a look ...

Thanks,

	Ingo
