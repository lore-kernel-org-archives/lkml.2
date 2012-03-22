Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2CVOI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:08:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab2CVOI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:08:27 -0400
Date: Thu, 22 Mar 2012 15:07:25 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] perf, tool: Add new event group management
Message-ID: <20120322140725.GC1601@m.brq.redhat.com>
References: <1332269081.18960.444.camel@twins>
 <20120320204625.GA17142@gmail.com>
 <1332321311.18960.474.camel@twins>
 <20120321095211.GA11122@gmail.com>
 <1332330852.18960.482.camel@twins>
 <20120321121510.GA4386@gmail.com>
 <20120321151332.GD21163@infradead.org>
 <20120322075634.GD31810@gmail.com>
 <20120322124137.GF21163@infradead.org>
 <20120322135428.GA3068@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120322135428.GA3068@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 02:54:29PM +0100, Ingo Molnar wrote:
> 
> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> 
> > Em Thu, Mar 22, 2012 at 08:56:34AM +0100, Ingo Molnar escreveu:
> > > 
> > > * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> > > 
> > > > Em Wed, Mar 21, 2012 at 01:15:10PM +0100, Ingo Molnar escreveu:
> > > > > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > > > > I would much prefer a syntax that's more natural but requires 
> > > > > > quoting than one that's quirky and tailor made to avoid 
> > > > > > whatever current bash does. For one, there's other shells out 
> > > > > > there that might have different quoting needs and bash is of 
> > > > > > course free to extend its syntax.
> > > > > 
> > > > > Well, they are unlikely to extend to '+', it would break a 
> > > > > boatload of scripts I suspect.
> > > > > 
> > > > > So the question would be, is a+b+c as event grouping a natural 
> > > > > syntax? If not then lets use a quoted one that is.
> > > > 
> > > >    -e groupname=event1,event2,event3
> > > > 
> > > > Seems intuitive, no?
> > > 
> > > Hm, if there's no use for 'groupname' later on then it's a 
> > > needlessly unspecified dimension. If this variant is picked then 
> > > I'd suggest to make it a fixed:
> > > 
> > >   -e group=event1,event2,event3
> > > 
> > > kind of thing instead.
> > 
> > Jiri mentioned a use for the group name, no?
> 
> Only for perf stat output, right?
> 

right.. hm, using it in perf report would need to have it
stored in the data file.. not sure thats worth the effort

maybe let's start with 'group:mod=' and we can add later something
like 'group/name:mod=' if there's need to see group name in output

I think it's better to have one event syntax for all commands

jirka
