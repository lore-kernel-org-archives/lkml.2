Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab2LWXJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 18:09:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab2LWXJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 18:09:07 -0500
Date: Sun, 23 Dec 2012 21:08:48 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-kernel@vger.kernel.org, walken@google.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3] x86,smp: auto tune spinlock backoff delay factor
Message-ID: <20121223230847.GC4186@x61.redhat.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
 <20121221185147.4ae48ab5@annuminas.surriel.com>
 <50D5033A.2070309@gmail.com>
 <50D52037.60602@redhat.com>
 <20121222034910.GG27621@home.goodmis.org>
 <50D52FF8.1050104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D52FF8.1050104@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 10:58:48PM -0500, Rik van Riel wrote:
> On 12/21/2012 10:49 PM, Steven Rostedt wrote:
> >On Fri, Dec 21, 2012 at 09:51:35PM -0500, Rik van Riel wrote:
> 
> >>However, since spinlock contention should not be the
> >>usual state, and all a scalable lock does is make sure
> >>that N+1 CPUs does not perform worse than N CPUs, using
> >>scalable locks is a stop-gap measure.
> >>
> >>I believe a stop-gap measure should be kept as simple as
> >>we can. I am willing to consider moving to a per-lock
> >>delay factor if we can figure out an easy way to do it,
> >>but I would like to avoid too much extra complexity...
> >
> >Rik,
> >
> >I like your solution. It's rather simple and simple solutions tend to
> >end up being the closest to optimal. The more complex a solution gets,
> >the more it starts chasing fireflies.
> 
> >Anyway, I'd like to see this code tested, and more benchmarks run
> >against it.
> 
> Absolutely.  I would love to see if this code actually
> causes regressions anywhere.
> 
> It is simple enough that I suspect it will not, but there
> really is only one way to find out.
> 
> The more people test this with different workloads on
> different SMP systems, the better.
>

Great work Rik,

I have a couple of small SMP systems I'll start to test with your patches, also
I might be able to test this work after new year's eve on a big SMP box that 
seems to be facing a severe lock starvation issue due to the BUS saturation 
your work is aiming to reduce.

Cheers!
-- Rafael
