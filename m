Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1G1TTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 15:19:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58415 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799Ab1G1TTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 15:19:10 -0400
Date: Thu, 28 Jul 2011 21:18:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage
Message-ID: <20110728191824.GB17308@elte.hu>
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com>
 <CA+55aFwtyfzaFABHKD+OMWsojGov0JLmnrZimhVaOcrer=tJjQ@mail.gmail.com>
 <20110728152753.GA19409@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110728152753.GA19409@windriver.com>
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


* Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> >  - how much does this actually improve compile times (for a 
> > "normal" build or a "allmodconfig" one)?
> 
> Let me run some "real world" use cases and get back to you in a 
> couple of hours with that.  But Ingo's testing on a much earlier 
> snapshot was showing roughly a couple percent.  ( 
> https://lkml.org/lkml/2011/5/28/60 )

I found that it's pretty hard to measure these things accurately and 
reliably, kernel build times are very noisy.

Note that you can use my numbers to estimate expected savings: just 
build before/after .i files in a common directory like kernel/*.c and 
measure their combined size. The size decrease of the preprocessor 
output scales almost linearly with runtime.

You could standardize on that kind of metric "these patches decrease 
preprocessor output by 0.5%" - those translate almost 1:1 into 
compile time speedups, and you don't really have to re-measure 
compile times every time you come up with such patches.

Thanks,

	Ingo
