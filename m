Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab0CYJ11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:27:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:56572 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750903Ab0CYJ1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:27:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/DpxYZ1u7DE3H4V2Gkj0TOn6Pt8aT/9+AD4JU3Um
	/sbjsD1w07c4nK
Subject: Re: [BUG] perf: hard lockup when using perf-sched
From: Mike Galbraith <efault@gmx.de>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <4BAB1924.4060304@cn.fujitsu.com>
References: <4BA082EC.8030101@cn.fujitsu.com>
	 <4BA9A885.9050105@cn.fujitsu.com>
	 <1269415964.6530.25.camel@marge.simson.net>
	 <1269418671.6465.6.camel@marge.simson.net>
	 <4BAB1924.4060304@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 25 Mar 2010 10:27:21 +0100
Message-Id: <1269509241.8438.30.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 16:04 +0800, Li Zefan wrote:
> Mike Galbraith wrote:
> > On Wed, 2010-03-24 at 08:32 +0100, Mike Galbraith wrote:
> > 
> >> I just saw this, hunted down your testcase and tried it here.  Looks
> >> like perf_output_lock() wedged box.
> > 
> > (turns on frame pointers, and adds noinline)
> > 
> 
> Thanks! Then who's going to fix this...

Well, that kinda depends on whether I figure out how the heck it's all
supposed to work before somebody else whacks it or not.

ATM, I've instrumented, know _what's_ happening, but find myself saying
"wtf?" a lot, especially wrt handle->locked.  The act of attempting to
lock a handle declares it unlocked, turning perf_output_unlock() into a
noop, which looks a bit strange.  We're spinning on those "unlocked"
locks, all left genuinely locked by one CPU.  I just whacked the thing,
and am very likely about to see in yet another trace.

Locking is hard, "curious construct" locking is even harder :)

	-Mike

