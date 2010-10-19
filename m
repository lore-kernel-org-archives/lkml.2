Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab0JSGkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 02:40:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36297 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab0JSGkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 02:40:10 -0400
Date: Tue, 19 Oct 2010 08:40:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gitonga Marete <marete@toshnix.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] [PERF] (Userspace Tools) Fix a compilation error with
 -fstack-protector and -Werror
Message-ID: <20101019064000.GC21782@elte.hu>
References: <AANLkTinHc7tMntW5NFAhu40RC7m2=HwbqOBeE-21vL8J@mail.gmail.com>
 <20101018233834.GC5370@nowhere>
 <AANLkTi=Ssz4WdMDXq-93GE9bPHoaQ8QyTSrWXDSCa7eH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=Ssz4WdMDXq-93GE9bPHoaQ8QyTSrWXDSCa7eH@mail.gmail.com>
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

> On Tue, Oct 19, 2010 at 2:38 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Tue, Oct 19, 2010 at 02:24:00AM +0300, Brian Gitonga Marete wrote:
> >> The following patch fixes compilation of the perf user-space tools on,
> >> for example, gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) . It should not
> >> break anything else.
> >
> >
> >
> > Hi,
> >
> > What kind of warning have you encountered and why it fixes it?
> > Can you describe that in your changelog?
> >
> 
> Hello Frederic,
> 
> Some versions of gcc, e.g. gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4), have the 
> (default) minimum size of buffers protected by `-fstack-protector' set to 8. But 
> in perf, there exist much smaller automatic buffers.

Hm, it's this code:

        /* newtWinChoice should really be accepting const char pointers... */
        char yes[] = "Yes", no[] = "No";
        return newtWinChoice(NULL, yes, no, (char *)msg) == 1;

I.e. the code is messy and GCC is right to warn about it. Hence it would be somewhat 
bad to actually remove the warning that pointed out some dodgy piece of code.

Even if marking it const doesnt work due to the external libnewt API, we could at 
least put 'yes' and 'no' into file scope and mark them static?

	Ingo
