Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab0CQKAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:00:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43630 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab0CQKAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:00:12 -0400
Date: Wed, 17 Mar 2010 10:59:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: T?r?k Edwin <edwintorok@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: x86: fix callgraphs of 32-bit processes on 64-bit
 kernels V2.
Message-ID: <20100317095957.GG17146@elte.hu>
References: <20100316144906.GA5621@nowhere>
 <1268751734-9167-1-git-send-email-edwintorok@gmail.com>
 <20100316170549.GC17537@elte.hu>
 <4BA09776.4020205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA09776.4020205@gmail.com>
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


* T?r?k Edwin <edwintorok@gmail.com> wrote:

> >> +	    }
> >> +	    return;
> > 
> > This whole new block should probably be in a helper inline?
> 
> To reduce indenting, or why?

Mainly to increase cleanliness. We want code that isolates separate blocks of 
logic into separate sections. So a simple construct of:

        if (perf_callchain_user32(regs, entry))
                return;

will tell the reader of the code that 'ok, this is 32-bit compat stuff'. It 
doesnt, at this level, intrude into the main logic of that function. Then if 
we look at perf_callchain_user32() we see all the 32-bit compat stack frame 
walking details.

Thanks,

	Ingo
