Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab1FWHE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 03:04:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47530 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab1FWHE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 03:04:58 -0400
Date: Thu, 23 Jun 2011 09:04:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: ling.ma@intel.com, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [x86] Optimize copy-page by reducing impact from HW
 prefetch
Message-ID: <20110623070448.GA25707@elte.hu>
References: <1308351117-32452-1-git-send-email-ling.ma@intel.com>
 <m2fwn13a3u.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2fwn13a3u.fsf@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> ling.ma@intel.com writes:
>
> > impact(DCU prefetcher), and simplify original code. The 
> > performance is improved about 15% on core2, 36% on snb 
> > respectively. (We use our micro-benchmark, and will do further 
> > test according to your requirment)
> 
> This doesn't make a lot of sense because neither Core-2 nor SNB use 
> the code path you patched. They all use the rep ; movs path

Ling, mind double checking which one is the faster/better one on SNB, 
in cold-cache and hot-cache situations, copy_page or copy_page_c?

Also, while looking at this file please fix the countless pieces of 
style excrements it has before modifying it:

 - non-Linux comment style (and needless two comments - it can 
   be in one comment block):

  /* Don't use streaming store because it's better when the target
     ends up in cache. */
            
  /* Could vary the prefetch distance based on SMP/UP */

 - (there's other non-standard comment blocks in this file as well)

 - The copy_page/copy_page_c naming is needlessly obfuscated, it 
   should be copy_page, copy_page_norep or so - the _c postfix has no
   obvious meaning.

 - all #include's should be at the top

 - please standardize it on the 'instrn %x, %y' pattern that we 
   generally use in arch/x86/, not 'instrn %x,%y' pattern.

and do this cleanup patch first and the speedup on top of it, and 
keep the two in two separate patches so that the modification to the 
assembly code can be reviewed more easily.

Thanks,

	Ingo
