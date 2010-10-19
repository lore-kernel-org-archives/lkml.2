Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab0JSLtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:49:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59163 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758542Ab0JSLtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:49:13 -0400
Date: Tue, 19 Oct 2010 13:49:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gitonga Marete <marete@toshnix.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] [PERF] (Userspace Tools) Fix a compilation error with
 -fstack-protector and -Werror
Message-ID: <20101019114904.GB25371@elte.hu>
References: <AANLkTinHc7tMntW5NFAhu40RC7m2=HwbqOBeE-21vL8J@mail.gmail.com>
 <20101018233834.GC5370@nowhere>
 <AANLkTi=Ssz4WdMDXq-93GE9bPHoaQ8QyTSrWXDSCa7eH@mail.gmail.com>
 <20101019064000.GC21782@elte.hu>
 <AANLkTimqaTKu23HrgbffAht_Otn9L5k2oHMZDGki8MK+@mail.gmail.com>
 <AANLkTin=0N0b=wK8974RGwXuTxpQ4BtH4bHwjsea+1tS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin=0N0b=wK8974RGwXuTxpQ4BtH4bHwjsea+1tS@mail.gmail.com>
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


* Brian Gitonga Marete <marete@toshnix.com> wrote:

> > OK. Now that I actually look closely at that fragment I can see its useless to 
> > create the automatic arrays. Local string literals would also work (i.e. just 
> > pass `"Yes"' and `"No"' to newtWinChoice). But can also do what you suggested if 
> > it is anticipated that they will be used somewhere else within the file at some 
> > other time -- Currently they are not.
> 
> Oops. Sorry. What I suggested won't work because of the -Wwrite-strings default 
> option. Which actually makes me understand why the original author of the code 
> made it the way it is. Your suggestion of file-scope, static does solve the 
> problem.

Btw., -Wwrite-strings has proven to be a really useful warning in practice, in that 
it ensured that we propagate string immutability/const-ness as widely as possible. 
This resulted is cleaner perf code in the long run.

Here we cannot fix the Newt prototype (it's an existing library outside of our 
control) to take a const so we have to do the (mild) workaround of moving it to file 
scope. (if this becomes common then we'd have to re-evaluate the use of this 
warning)

I think Arnaldo has plans to get rid of the libnewt dependency altogether - that 
might be a fix too.

Thanks,

	Ingo
