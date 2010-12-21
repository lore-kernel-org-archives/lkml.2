Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab0LUN5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 08:57:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab0LUN5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 08:57:12 -0500
Message-ID: <4D10B214.8010305@redhat.com>
Date: Tue, 21 Dec 2010 15:56:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 00/15] Nohz task support
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com> <1292859886.22905.22.camel@gandalf.stny.rr.com> <20101220233341.GA1715@nowhere>
In-Reply-To: <20101220233341.GA1715@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 01:33 AM, Frederic Weisbecker wrote:
> On Mon, Dec 20, 2010 at 10:44:46AM -0500, Steven Rostedt wrote:
> >  On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> >  >  The timer interrupt handles several things like preemption,
> >  >  timekeeping, rcu, etc...
> >  >
> >  >  However it appears that sometimes it is simply useless like
> >  >  when a task runs alone and even more when it is in userspace
> >  >  as RCU doesn't need it at all in such case.
> >  >
> >  >  It appears that HPC workload would get some win of such timer
> >  >  deactivation, and perhaps also the Real Time world as this
> >  >  minimizes the critical sections due to way less interrupts to
> >  >  handle.
> >  >
> >  >  It works through the procfs interface:
> >  >
> >  >  echo 1>  /proc/self/nohz
> >
> >  I wounder if we could just have this happen automatically.
>
> But this would add some global overhead, especially in the syscall
> path as we need to take the slow path to hook userspace resume/exit.

This is zero as there is already a test on thread_info->flags on the 
syscall exit path.

(or I misunderstood you - what's the purpose of the slow path?)

-- 
error compiling committee.c: too many arguments to function

