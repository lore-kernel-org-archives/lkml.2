Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0KWXK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:10:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50254 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0KWXK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:10:59 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=dloADZ4KP7gA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=LOtuBjw39QaveXUNaxYA:9 a=QnTTQ47kqJGoA3nP97OgwSQh7W4A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/3] jump label: updates for 2.6.37
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101123215604.GC4715@redhat.com>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <1290548527.30543.401.camel@gandalf.stny.rr.com>
	 <20101123215604.GC4715@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 23 Nov 2010 18:10:54 -0500
Message-ID: <1290553854.30543.406.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 16:56 -0500, Jason Baron wrote:
> On Tue, Nov 23, 2010 at 04:42:07PM -0500, Steven Rostedt wrote:
> > On Tue, 2010-11-23 at 16:27 -0500, Jason Baron wrote:
> > > Hi,
> > > 
> > > A few jump label patches that I want considered for 2.6.37. Patches are against
> > > the latest -tip tree.
> > 
> > I can see patch 2 and 3 going to 2.6.37, but patch 1 seems a bit too
> > big. If it is not a true fix for anything and is just a design change,
> > then lets hold off till 2.6.38.
> > 
> > 
> > > 
> > > The first one, which adds 'state' to the jump label mechanism is the most
> > > important. Essentially, it ensures that if jump labels are enabled/disabled in
> > > the core kernel but the actual call sites are in modules, we properly honor the
> > > state of the jump label. This also works for jump labels which may be defined in
> > > one module but made use of in another module.
> > 
> > What happens if we don't do this. What does "honoring" the state
> > actually mean?
> > 
> 
> So for example, let's say we do:
> 
> 1) echo 1 > /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
> 2) load module 'A' that has the 'kmalloc' tracepoint.
> 
> Without patch #1, we would fail to trace the 'kmalloc' in module 'A'.
> The only way to get the output from the 'kmalloc' tracepoint in module
> 'A', would be to issue the echo command again.
> 
> To me this is a correctness patch, and should be included.
> 

It's not what you think that matters, it's what Linus thinks ;-)
He just wants bug fixes.

Anyway, I just tried what you explained with the current kernel, with
and without jump labels and, without jump labels, the module has its
kmalloc tracepoint traced, but with jump labels it does not. So we can
treat this as a regression, which is something that can go into an -rc.

The change log must state that this _is_ a regression, or Linus may not
accept it.

I'll test out your patches.

-- Steve


