Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab0LOIDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 03:03:00 -0500
Received: from www.tglx.de ([62.245.132.106]:36507 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab0LOIC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 03:02:59 -0500
Date: Wed, 15 Dec 2010 09:02:38 +0100 (CET)
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
In-Reply-To: <1292379516.5015.1837.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1012150850380.12146@localhost6.localdomain6>
References: <4D07330A.7020600@cn.fujitsu.com> <1292379516.5015.1837.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010, Steven Rostedt wrote:

> On Tue, 2010-12-14 at 17:04 +0800, Lai Jiangshan wrote:
> 
> OK, I was looking at this in a bit more detail (the coffee finally set
> in) and I was at first looking to nuke the cand_owner since it is
> redundant to cand_seq. But I think we can nuke the cand_seq instead and
> use the top_waiter as the decider.

So you just use cand_owner (the name sucks) to flag that the waiter
has been woken up either by the boost code or by an unlock. The waiter
clears that flag with waiter->lock->wait_lock held before calling
schedule().

Though I think we do need it at all. wakeup of an already running task
is almost a nop, so having one less state to worry about is good.

Thanks,

	tglx
