Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab0EaS2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 14:28:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:34749 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab0EaS2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 14:28:45 -0400
Subject: Re: [PATCH] tracing: Add task activate/deactivate tracepoints
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1275323853.15884.14.camel@gandalf.stny.rr.com>
References: <1275056762-13130-1-git-send-regression-fweisbec@gmail.com>
	 <1275059710.27810.9624.camel@twins> <20100531080049.GA435@elte.hu>
	 <1275293544.27810.21478.camel@twins> <1275296099.27810.21622.camel@twins>
	 <20100531143622.GA5157@nowhere> <1275317013.27810.23019.camel@twins>
	 <20100531144820.GB5157@nowhere>  <1275322715.27810.23323.camel@twins>
	 <1275323853.15884.14.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 20:28:42 +0200
Message-ID: <1275330522.1645.523.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 12:37 -0400, Steven Rostedt wrote:
> >  
> > +#ifdef CREATE_TRACE_POINTS
> 
> I guess this could work. I can't think of anything that would cause this
> to fail. But this is not exactly what the CREATE_TRACE_POINTS macro was
> for.
> 
> Maybe we could make a CREATE_UTIL_FUNCTIONS macro that the
> define_trace.h can unset like it does with CREATE_TRACE_POINTS before
> recursively including the trace headers.
> 
> Maybe I'm a bit paranoid, but I'm a little nervous to extend the
> CREATE_TRACE_POINTS macro to be used within the header to create utility
> functions, although, currently I don't think there's anything
> technically wrong in doing so. 

Right, I can attest to the compile mess that results in not having
it :-) Given that, I think we're fairly safe with stretching it like
this, the compiler will yell real loud if you mess this up. So I'm not
sure you need to be very paranoid about this.

Duplicating the whole CREATE_TRACE_POINT logic just for a different name
doesn't seem worth the effort at this time, esp. given the compiler
results if you get it wrong.

So do you object if I merge this for now, or would you really rather see
something else?

