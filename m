Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab0JSNMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:12:01 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43350 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab0JSNMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:12:00 -0400
Date: Tue, 19 Oct 2010 11:11:52 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Brian Gitonga Marete <marete@toshnix.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] [PERF] (Userspace Tools) Fix a compilation error with
	-fstack-protector and -Werror
Message-ID: <20101019131152.GB3826@ghostprotocols.net>
References: <AANLkTinHc7tMntW5NFAhu40RC7m2=HwbqOBeE-21vL8J@mail.gmail.com> <20101018233834.GC5370@nowhere> <AANLkTi=Ssz4WdMDXq-93GE9bPHoaQ8QyTSrWXDSCa7eH@mail.gmail.com> <20101019064000.GC21782@elte.hu> <AANLkTimqaTKu23HrgbffAht_Otn9L5k2oHMZDGki8MK+@mail.gmail.com> <AANLkTin=0N0b=wK8974RGwXuTxpQ4BtH4bHwjsea+1tS@mail.gmail.com> <20101019114904.GB25371@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019114904.GB25371@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 19, 2010 at 01:49:04PM +0200, Ingo Molnar escreveu:
> 
> * Brian Gitonga Marete <marete@toshnix.com> wrote:
> 
> > > OK. Now that I actually look closely at that fragment I can see its useless to 
> > > create the automatic arrays. Local string literals would also work (i.e. just 
> > > pass `"Yes"' and `"No"' to newtWinChoice). But can also do what you suggested if 
> > > it is anticipated that they will be used somewhere else within the file at some 
> > > other time -- Currently they are not.
> > 
> > Oops. Sorry. What I suggested won't work because of the -Wwrite-strings default 
> > option. Which actually makes me understand why the original author of the code 
> > made it the way it is. Your suggestion of file-scope, static does solve the 
> > problem.
> 
> Btw., -Wwrite-strings has proven to be a really useful warning in practice, in that 
> it ensured that we propagate string immutability/const-ness as widely as possible. 
> This resulted is cleaner perf code in the long run.
> 
> Here we cannot fix the Newt prototype (it's an existing library outside of our 
> control) to take a const so we have to do the (mild) workaround of moving it to file 
> scope. (if this becomes common then we'd have to re-evaluate the use of this 
> warning)
> 
> I think Arnaldo has plans to get rid of the libnewt dependency altogether - that 
> might be a fix too.

Yeah, but for now I'll just reap the results of this long discussion
about this issue. :)

- Arnaldo
