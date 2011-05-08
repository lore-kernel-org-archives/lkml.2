Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab1EHVIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 17:08:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34284 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab1EHVIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 17:08:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WDtq00PWXHjIQGaJlejktzjF0SrAbKnn7DM6CvSbEucBdSGotv2jPccKcAifCqofI4
         iooStWWb5eMlrjwivOx/UXRuz97aYHDGWyoxG12EaZcwNIcRYGCcEpY1xQWUZsgXAAVS
         Bz0tizjQw9frW67yHgfMZ9hVYHB+8n7vBDX2M=
Date: Sun, 8 May 2011 23:08:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
Message-ID: <20110508210815.GA2014@nowhere>
References: <4DC45537.6070609@linux.intel.com>
 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
 <20110507065803.GA23414@elte.hu>
 <1304765110.25414.2564.camel@gandalf.stny.rr.com>
 <20110507144402.GC2859@elte.hu>
 <1304788829.11129.57.camel@frodo>
 <4DC58888.9030402@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC58888.9030402@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 07, 2011 at 10:59:36AM -0700, Arjan van de Ven wrote:
> On 5/7/2011 10:20 AM, Steven Rostedt wrote:
> >On Sat, 2011-05-07 at 16:44 +0200, Ingo Molnar wrote:
> >>* Steven Rostedt<rostedt@goodmis.org>  wrote:
> >>
> >>>2) we separate perf from ftrace and keep the "stable" ABI for perf, and let
> >>>ftrace advance into a more efficient tracer.
> >>The thing is, ftrace is still largely separated from perf, and this is why this
> >>regression came in: a random tracing 'cleanup' churn was done to 'tracing'
> >>which broke PowerTop.
> >>
> >>Look at the commit itself:
> >>
> >>   e6e1e2593592: tracing: Remove lock_depth from event entry
> >>
> >>Clearly you didnt even *realize* that there's a whole tooling world behind this
> >>mechanism ...
> >Note, I discussed this change with Frederic and he totally agreed with
> >me on removing it. In fact, we are in discussions about getting rid of
> >pid, preempt-count, and irq flags as well. But according to your logic,
> >that is a no go. I guess Frederic also does not *realize* there's a
> >whole tooling world behind this mechanism too.
> 
> btw if you remove some of these, how is userland supposed to find
> out if an event happened in irq context?

You can use the irq events for that.
