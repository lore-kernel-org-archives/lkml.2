Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab2CUMPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 08:15:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63673 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502Ab2CUMPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 08:15:17 -0400
Date: Wed, 21 Mar 2012 13:15:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] perf, tool: Add new event group management
Message-ID: <20120321121510.GA4386@gmail.com>
References: <1332267341-26338-1-git-send-email-jolsa@redhat.com>
 <1332267341-26338-4-git-send-email-jolsa@redhat.com>
 <1332269081.18960.444.camel@twins>
 <20120320204625.GA17142@gmail.com>
 <1332321311.18960.474.camel@twins>
 <20120321095211.GA11122@gmail.com>
 <1332330852.18960.482.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332330852.18960.482.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2012-03-21 at 10:52 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > # echo {}
> > > {}
> > > # echo {en,dis}able
> > > enable disable
> > > 
> > > 
> > > It somehow special cases {}, which is horrible.
> > 
> > Oh, indeed: brace expansion and sequence expressions both use 
> > curly braces:
> > 
> >  $ echo foo-{a,b,c}-bar
> >  foo-a-bar foo-b-bar foo-c-bar
> > 
> >  $ echo {1..10}
> >  1 2 3 4 5 6 7 8 9 10
> > 
> > Too bad, it would be rather intuitive. All the brace characters 
> > are taken by Bash.
> > 
> > Maybe something like:
> > 
> >  $ echo /minor-faults,major-faults/
> >  /minor-faults,major-faults/
> > 
> > although it looks a bit weird.
> > 
> > So ... how about using another grouping operator, such as '+'?
> > 
> > Something like:
> > 
> >  -e minor-faults+major-faults
> > 
> > While when comma separated they are not grouped, or so.
> 
> I would much prefer a syntax that's more natural but requires 
> quoting than one that's quirky and tailor made to avoid 
> whatever current bash does. For one, there's other shells out 
> there that might have different quoting needs and bash is of 
> course free to extend its syntax.

Well, they are unlikely to extend to '+', it would break a 
boatload of scripts I suspect.

So the question would be, is a+b+c as event grouping a natural 
syntax? If not then lets use a quoted one that is.

Thanks,

	Ingo
