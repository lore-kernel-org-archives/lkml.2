Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab2CFH54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:57:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32877 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758329Ab2CFH5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:57:55 -0500
Date: Tue, 6 Mar 2012 08:57:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tglx@linutronix.de, hpa@zytor.com, alex.shi@intel.com, cl@gentwo.org,
        sfr@canb.auug.org.au, tj@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 5/8] x86: use this_cpu_xxx to replace percpu_xxx funcs
Message-ID: <20120306075740.GF23669@elte.hu>
References: <20120305230515.A9238A02AE@akpm.mtv.corp.google.com>
 <20120306074601.GD23669@elte.hu>
 <20120305235532.28f407bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305235532.28f407bf.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 6 Mar 2012 08:46:01 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Will percpu_write() be removed altogether? If so then the 
> > changelog should say *that*, and explain that on x86 this is a 
> > simple renaming of the API, not a long explanation about 
> > scenarios that don't actually matter.
> > 
> > If percpu_write() is not being removed then I don't see how this 
> > patch is an improvement: it's supposed to result in the same 
> > instructions being emitted, and __this_cpu_write() et al are 
> > distinctly longer to write ...
> > 
> > So what's the plan here?
> 
> All percpu_xxx() functions get removed.

Fair enough - then please see my namespace comments for the 
other patch, before we start spreading these APIs to hundreds of 
places ...

Also, IMHO the lack of debugging API is troubling as well. 
Thomas found a couple of really, really hairy this_cpu related 
bugs.

Thanks,

	Ingo
