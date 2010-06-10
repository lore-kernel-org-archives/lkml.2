Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276Ab0FJPFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 11:05:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab0FJPFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 11:05:02 -0400
Date: Thu, 10 Jun 2010 11:04:22 -0400
From: Jason Baron <jbaron@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com, avi@redhat.com,
       davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org
Subject: Re: [PATCH 03/13] jump label v9: x86 support
Message-ID: <20100610150422.GA3923@redhat.com>
References: <cover.1276116186.git.jbaron@redhat.com>
 <c837d1a0a380030a4ea61acbcf0183518675a8ee.1276116186.git.jbaron@redhat.com>
 <1276171930.2077.200.camel@twins>
 <20100610121440.GA20130@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100610121440.GA20130@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 02:14:40PM +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2010-06-09 at 17:39 -0400, Jason Baron wrote:
> > > +       select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
> > 
> > That deserves a comment somewhere, it basically makes OPTIMIZE_FOR_SIZE 
> > useless...
> 
> Hm, we need more than a comment for that - distros enable CC_OPTIMIZE_FOR_SIZE 
> all the time, for the massive kernel image (and hotpath cache footprint) 
> savings. Is this fixable?
> 
> Thanks,
> 
> 	Ingo
> 

When I tested 'jump label' with CC_OPTIMIZE_FOR_SIZE, I saw a small
performance drop , b/c there is less block re-ordering happening. There
was a small gcc patch that Richard Henderson wrote to allow block
re-ordering while still taking size into account. However, it did
increase the text size somewhat from what current optimize for size
does. This small patch combined with jump labels resulted in the
expected performance gains. However, to keep the size to what it is now
a much more involved gcc patch would be required.

Thus, until this additional gcc optimization is done, I've posted this
as depends on !CC_OPTIMIZE_FOR_SIZE. If this gcc work is done, we can
lift this restriction. As mentioned, a number of large distros are
compiled !CC_OPTIMIZE_FOR_SIZE (rhel, sles), so we should still get a lot of
benefit from this. Also, if people find these patches useful we might
create some more impetus for the gcc work. So i see this as an iterative
thing.

thanks,

-Jason
