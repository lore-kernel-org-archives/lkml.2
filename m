Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0KKKZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:25:43 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52045 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab0KKKZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:25:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k4EiYXYaHX0oAvB+ZGIGkCEwNZKIiVihilMbZB97AQmMnWHGgnI5jHnsuqAlHrj6yb
         Ie1qJFSM75Dqu3EaOxT69sXHm8bxaAZ0xs7x8TNLZ46hTrdGKK21tnywKwQdT5nYGpFD
         BH7LcpVXVw3MiXsZVpobhKccWaviHi+FUq3Vs=
Subject: Re: [PATCH] [PERF] (Userspace Tools) Fix a compilation error with
 -fstack-protector and -Werror
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Brian Gitonga Marete <marete@toshnix.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20101019131152.GB3826@ghostprotocols.net>
References: <AANLkTinHc7tMntW5NFAhu40RC7m2=HwbqOBeE-21vL8J@mail.gmail.com>
	 <20101018233834.GC5370@nowhere>
	 <AANLkTi=Ssz4WdMDXq-93GE9bPHoaQ8QyTSrWXDSCa7eH@mail.gmail.com>
	 <20101019064000.GC21782@elte.hu>
	 <AANLkTimqaTKu23HrgbffAht_Otn9L5k2oHMZDGki8MK+@mail.gmail.com>
	 <AANLkTin=0N0b=wK8974RGwXuTxpQ4BtH4bHwjsea+1tS@mail.gmail.com>
	 <20101019114904.GB25371@elte.hu> <20101019131152.GB3826@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 11:25:35 +0100
Message-ID: <1289471135.17691.1026.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 19 octobre 2010 à 11:11 -0200, Arnaldo Carvalho de Melo a
écrit :
> Em Tue, Oct 19, 2010 at 01:49:04PM +0200, Ingo Molnar escreveu:
> > 
> > * Brian Gitonga Marete <marete@toshnix.com> wrote:
> > 
> > > > OK. Now that I actually look closely at that fragment I can see its useless to 
> > > > create the automatic arrays. Local string literals would also work (i.e. just 
> > > > pass `"Yes"' and `"No"' to newtWinChoice). But can also do what you suggested if 
> > > > it is anticipated that they will be used somewhere else within the file at some 
> > > > other time -- Currently they are not.
> > > 
> > > Oops. Sorry. What I suggested won't work because of the -Wwrite-strings default 
> > > option. Which actually makes me understand why the original author of the code 
> > > made it the way it is. Your suggestion of file-scope, static does solve the 
> > > problem.
> > 
> > Btw., -Wwrite-strings has proven to be a really useful warning in practice, in that 
> > it ensured that we propagate string immutability/const-ness as widely as possible. 
> > This resulted is cleaner perf code in the long run.
> > 
> > Here we cannot fix the Newt prototype (it's an existing library outside of our 
> > control) to take a const so we have to do the (mild) workaround of moving it to file 
> > scope. (if this becomes common then we'd have to re-evaluate the use of this 
> > warning)
> > 
> > I think Arnaldo has plans to get rid of the libnewt dependency altogether - that 
> > might be a fix too.
> 
> Yeah, but for now I'll just reap the results of this long discussion
> about this issue. :)
> 

Hi Arnaldo

Sorry if I missed something, but current linux-2.6 tree has the problem.

Is the fix under control ?

Thanks !


