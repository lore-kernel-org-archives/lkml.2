Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006Ab0FKAwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 20:52:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423Ab0FKAwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 20:52:53 -0400
Date: Thu, 10 Jun 2010 20:52:07 -0400
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 03/13] jump label v9: x86 support
Message-ID: <20100611005206.GA2379@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
 <c837d1a0a380030a4ea61acbcf0183518675a8ee.1276116186.git.jbaron@redhat.com>
 <1276171930.2077.200.camel@twins>
 <20100610121440.GA20130@elte.hu>
 <20100610150422.GA3923@redhat.com>
 <20100610161339.GA20448@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610161339.GA20448@Krystal>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 12:13:39PM -0400, Mathieu Desnoyers wrote:
> * Jason Baron (jbaron@redhat.com) wrote:
> > On Thu, Jun 10, 2010 at 02:14:40PM +0200, Ingo Molnar wrote:
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > On Wed, 2010-06-09 at 17:39 -0400, Jason Baron wrote:
> > > > > +       select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
> > > > 
> > > > That deserves a comment somewhere, it basically makes OPTIMIZE_FOR_SIZE 
> > > > useless...
> > > 
> > > Hm, we need more than a comment for that - distros enable CC_OPTIMIZE_FOR_SIZE 
> > > all the time, for the massive kernel image (and hotpath cache footprint) 
> > > savings. Is this fixable?
> > > 
> > > Thanks,
> > > 
> > > 	Ingo
> > > 
> > 
> > When I tested 'jump label' with CC_OPTIMIZE_FOR_SIZE, I saw a small
> > performance drop , b/c there is less block re-ordering happening.
> 
> Is this a performance drop compared to a jump-label-less kernel or
> compared to -O2 kernel compiled with jump labels ? Or both ?
> 
> Mathieu
> 

Hi Mathieu,

So I'm quoting tbench benchmark here. The performance drop was jump
label vs. all jump label patches backed out on -Os. If we move to -02,
both the no jump label patches and the jump label patches applied are
faster than all jump label patches backed out on -Os.

so:

jump labels -02 > no jump labels -02 > no jump labels -0s > jump lables
-Os

thanks,

-Jason
