Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1GUBAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 21:00:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:48425 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751949Ab1GUBAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 21:00:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/DcidXYMrDBnP8nwIp8bP8tMrzfrbEA0LdfmTn2A
	vJR3vI9Yvpozs4
Subject: Re: sched: fix/optimise some issues
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: stephan.baerwolf@tu-ilmenau.de, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, ncrao@google.com
In-Reply-To: <1311189090.29152.73.camel@twins>
References: <4E26DB41.9070002@tu-ilmenau.de>
	 <1311189090.29152.73.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jul 2011 03:00:09 +0200
Message-ID: <1311210009.7746.37.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 21:11 +0200, Peter Zijlstra wrote:
> On Wed, 2011-07-20 at 15:42 +0200, Stephan Bärwolf wrote:
> > In "check_preempt_tick()" (kernel/sched_fair.c:1093) a ulong
> > called "ideal_runtime" stores a timeslice of the current task
> > (scheduling entity). This time complies real cpu-time.
> > 
> > At the end of the same function (nr_running > 1) this (real) time
> > is compared with a virtual-runtime-delta. Obviously the timeunits
> > (real vs. virtual) didn't fit.
> > 
> > Using "wakeup_preempt_entity()" instead should fix this in a even
> > more general way.

(That's what I thought at first too)

> Hrm,. I'm fairly sure we did that on purpose and the thing that is
> missing is a big fat comment. People keep trying to fix that (me
> included).
> 
> I'll try and dig up the why and such.

Better to just kill it outright.  It's not doing that much anyway.

	-Mike

