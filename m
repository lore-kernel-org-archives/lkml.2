Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab2CEKn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:43:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab2CEKnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:43:25 -0500
Date: Mon, 5 Mar 2012 11:43:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alex Shi <alex.shi@intel.com>, tglx@linutronix.com,
        "mingo@redhat.com" <mingo@redhat.com>, hpa@zytor.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, andi.kleen@intel.com
Subject: Re: [RFC patch] spindep: add cross cache lines checking
Message-ID: <20120305104311.GA18556@elte.hu>
References: <1330917630.18835.44.camel@debian>
 <1330917889.18835.46.camel@debian>
 <1330926234.18835.51.camel@debian>
 <201203050941.56502.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203050941.56502.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 05 March 2012, Alex Shi wrote:
> > Subject: [PATCH] lockdep: add cross cache lines checking
> > 
> > Modern x86 CPU won't hold whole memory bus when executing 
> > 'lock' prefixed instructions unless the instruction 
> > destination is crossing 2 cache lines. If so, it is disaster 
> > of system performance.
> > 
> > Actually if the lock is not in the 'packed' structure, gcc 
> > places it safely under x86 arch. But seems add this checking 
> > in CONFIG_DEBUG_LOCK_ALLOC is harmless.
> 
> Have you tried making this a compile-time check using 
> __alignof__? I would say that any spinlock in a packed data 
> structure is basically a bug, even more so on most other 
> architectures besides x86.

agreed.

Thanks,

	Ingo
