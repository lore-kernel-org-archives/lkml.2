Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0KWV4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:56:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0KWV4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 16:56:52 -0500
Date: Tue, 23 Nov 2010 16:56:04 -0500
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] jump label: updates for 2.6.37
Message-ID: <20101123215604.GC4715@redhat.com>
References: <cover.1290546539.git.jbaron@redhat.com> <1290548527.30543.401.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290548527.30543.401.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 04:42:07PM -0500, Steven Rostedt wrote:
> On Tue, 2010-11-23 at 16:27 -0500, Jason Baron wrote:
> > Hi,
> > 
> > A few jump label patches that I want considered for 2.6.37. Patches are against
> > the latest -tip tree.
> 
> I can see patch 2 and 3 going to 2.6.37, but patch 1 seems a bit too
> big. If it is not a true fix for anything and is just a design change,
> then lets hold off till 2.6.38.
> 
> 
> > 
> > The first one, which adds 'state' to the jump label mechanism is the most
> > important. Essentially, it ensures that if jump labels are enabled/disabled in
> > the core kernel but the actual call sites are in modules, we properly honor the
> > state of the jump label. This also works for jump labels which may be defined in
> > one module but made use of in another module.
> 
> What happens if we don't do this. What does "honoring" the state
> actually mean?
> 

So for example, let's say we do:

1) echo 1 > /sys/kernel/debug/tracing/events/kmem/kmalloc/enable
2) load module 'A' that has the 'kmalloc' tracepoint.

Without patch #1, we would fail to trace the 'kmalloc' in module 'A'.
The only way to get the output from the 'kmalloc' tracepoint in module
'A', would be to issue the echo command again.

To me this is a correctness patch, and should be included.

thanks,

-Jason
