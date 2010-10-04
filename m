Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab0JDDIm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 23:08:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:45136 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751506Ab0JDDIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 23:08:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/jXNRODb/j9Lh4k6xbn/S2eOQmw5c8xYMBQL5Z0D
	3DEAkmsFe0tc+r
Subject: Re: [PATCH 0/3][RFC] Improve load balancing when tasks have large
 weight differential
From: Mike Galbraith <efault@gmx.de>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=TQnYGLPC=Pi0o1As83W6VdWdjvimZNSrGT4qW@mail.gmail.com>
References: <1285633798-26886-1-git-send-email-ncrao@google.com>
	 <1285682273.7469.3.camel@marge.simson.net>
	 <AANLkTin=Dic2UE55yUaam8NzGHTib=9s=x-wyzk03BU0@mail.gmail.com>
	 <1285724758.7440.11.camel@marge.simson.net>
	 <AANLkTi=TQnYGLPC=Pi0o1As83W6VdWdjvimZNSrGT4qW@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 04 Oct 2010 05:08:37 +0200
Message-Id: <1286161717.7410.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late reply.  (fired up your patchlet bright and early so
it didn't rot in my inbox any longer;)

On Wed, 2010-09-29 at 12:32 -0700, Nikhil Rao wrote:
> On Tue, Sep 28, 2010 at 6:45 PM, Mike Galbraith <efault@gmx.de> wrote:
> > On Tue, 2010-09-28 at 14:15 -0700, Nikhil Rao wrote:
> >
> >> Thanks for running this. I've not been able to reproduce what you are
> >> seeing on the few test machines that I have (different combinations of
> >> MC, CPU and NODE domains). Can you please give me more info about
> >> your setup?
> >
> > It's a plain-jane Q6600 box, so has only MC and CPU domains.
> >
> > It doesn't necessarily _instantly_ "stick", can take a couple tries, or
> > a little time.
> 
> The closest I have is a quad-core dual-socket machine (MC, CPU
> domains). And I'm having trouble reproducing it on that machine as
> well :-( I ran 5 soaker threads (one of them niced to -15) for a few
> hours and didn't see the problem. Can you please give me some trace
> data & schedstats to work with?

Booting with isolcpus or offlining the excess should help.

> Looking at the patch/code, I suspect active migration on the CPU
> scheduling domain pushes the nice 0 task (running on the same socket
> as the nice -15 task) to the other socket. This leaves you with an
> idle core on the nice -15 socket, and with soaker threads there is no
> way to come back to a 100% utilized state. One possible explanation is
> the group capacity for a sched group in the CPU sched domain is
> rounded to 1 (instead of 2). I have a patch below that throws a hammer
> at the problem and uses group weight instead of group capacity (this
> is experimental, will refine it if it works). Can you please see if
> that solves the problem?

Nope, didn't help.  I'll poke at it, but am squabbling elsewhere atm.

	-Mike

