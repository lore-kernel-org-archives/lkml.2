Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab0DFJZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 05:25:57 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:57649 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab0DFJZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 05:25:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Cv1wE2eJsRc1MyM4+/dAwM/TVqab44t6UKCt7Dua4L+f6SrA/m9JldeYlgPP2eJCLD
         5VQ7p2c191l3P23umN7uS5acGS1h7ojDETcez1g7dzwOmJaZKISYcYJKKirZBDZBUsA+
         boGssKFb/D9hsy15HERjSqRMFjZX6D/Z5R7QA=
Date: Tue, 6 Apr 2010 11:25:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] lockdep: Make lockstats counting per cpu
Message-ID: <20100406092544.GB5147@nowhere>
References: <1269736197-10958-1-git-send-regression-fweisbec@gmail.com> <1270505417-8144-1-git-send-regression-fweisbec@gmail.com> <1270543587.1597.742.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270543587.1597.742.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 10:46:27AM +0200, Peter Zijlstra wrote:
> On Tue, 2010-04-06 at 00:10 +0200, Frederic Weisbecker wrote:
> > Locking statistics are implemented using global atomic variables.
> > This is usually fine unless some path write them very often.
> > 
> > This is the case for the function and function graph tracers
> > that disable irqs for each entry saved (except if the function
> > tracer is in preempt disabled only mode).
> > And calls to local_irq_save/restore() increment hardirqs_on_events
> > and hardirqs_off_events stats (or similar stats for redundant
> > versions).
> > 
> > Incrementing these global vars for each function ends up in too
> > much cache bouncing if lockstats are enabled.
> > 
> > To solve this, implement the debug_atomic_*() operations using
> > per cpu vars.
> > 
> > 
> 
> So I really have to ask, why?
> 
> This is CONFIG_DEBUG_LOCKDEP code, so its default off, and used to debug
> lockdep. Debug code should be as simple as possible, and preferably
> should not care about performance where possible.
> 
> So why complicate this?
> 


Also at worst it adds no more than 20 lines of code...

