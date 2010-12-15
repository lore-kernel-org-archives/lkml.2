Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0LOOvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:51:11 -0500
Received: from www.tglx.de ([62.245.132.106]:38668 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab0LOOvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:51:10 -0500
Date: Wed, 15 Dec 2010 15:50:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] rtmutex: multiple candidate owners without unrelated
 boosting
In-Reply-To: <1292423557.5015.1868.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1012151549570.12146@localhost6.localdomain6>
References: <4D07330A.7020600@cn.fujitsu.com>  <1292379516.5015.1837.camel@gandalf.stny.rr.com>  <alpine.LFD.2.00.1012150850380.12146@localhost6.localdomain6>  <1292421766.5015.1866.camel@gandalf.stny.rr.com>  <alpine.LFD.2.00.1012151515230.12146@localhost6.localdomain6>
 <1292423557.5015.1868.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Steven Rostedt wrote:

> On Wed, 2010-12-15 at 15:16 +0100, Thomas Gleixner wrote:
> > On Wed, 15 Dec 2010, Steven Rostedt wrote:
> > 
> 
> > That does not matter. The interesting part is whether the lock on
> > which orig_waiter is blocked on was unlocked. Lai's follow up patch does:
> > 
> > +       if (orig_waiter && !rt_mutex_owner(orig_lock))
> >                 goto out_unlock_pi;
> > 
> 
> I haven't looked at his new patch yet. But if this is the case, then we
> can nuke all cand_* fields. This was the only reason I kept the
> cand_owner in the first place.

Lai nuked it completely.
