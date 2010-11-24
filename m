Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab0KXJVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 04:21:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39843 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0KXJV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 04:21:29 -0500
Date: Wed, 24 Nov 2010 10:21:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] jump label: updates for 2.6.37
Message-ID: <20101124092123.GA4417@basil.fritz.box>
References: <cover.1290546539.git.jbaron@redhat.com>
 <1290548527.30543.401.camel@gandalf.stny.rr.com>
 <20101123215604.GC4715@redhat.com>
 <1290553854.30543.406.camel@gandalf.stny.rr.com>
 <1290587362.2072.429.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290587362.2072.429.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 09:29:22AM +0100, Peter Zijlstra wrote:
> On Tue, 2010-11-23 at 18:10 -0500, Steven Rostedt wrote:
> 
> > Anyway, I just tried what you explained with the current kernel, with
> > and without jump labels and, without jump labels, the module has its
> > kmalloc tracepoint traced, but with jump labels it does not. So we can
> > treat this as a regression, which is something that can go into an -rc.
> > 
> > The change log must state that this _is_ a regression, or Linus may not
> > accept it.
> 
> I really dislike the first patch... Preferably I'd simply fully revert
> all the jump-label stuff and try again next round with a saner
> interface.

Agreed.

> 
> There's a really good simple fix for this, simply disable the gcc
> trickery for .37 and use the fallback.
> 
> Then for .38, mandate the key type to be atomic_t * and switch to the
> SWITCH_POINT() interface from hpa.

This would also allow getting rid of the hash tables and use
binary search, which is imho much cleaner and simpler.

I will refresh my older patches to do that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
