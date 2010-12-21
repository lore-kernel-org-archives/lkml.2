Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab0LUOAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 09:00:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0LUOAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 09:00:39 -0500
Message-ID: <4D10B2E9.9040806@redhat.com>
Date: Tue, 21 Dec 2010 16:00:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 15/15] nohz_task: Procfs interface
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>	 <1292858662-5650-16-git-send-email-fweisbec@gmail.com>	 <1292859744.5021.4.camel@laptop> <20101220155737.GA1742@nowhere>	 <1292861799.5021.27.camel@laptop>  <20101221012418.GI1715@nowhere> <1292919280.5021.203.camel@laptop>
In-Reply-To: <1292919280.5021.203.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 10:14 AM, Peter Zijlstra wrote:
> On Tue, 2010-12-21 at 02:24 +0100, Frederic Weisbecker wrote:
> >
> >  >  Also, I'm not quite happy with the pure userspace restriction, but at
> >  >  least I see why you did that event though you didn't mention that.
> >
> >  What do you mean? The fact that kernel threads can not be nohz task?
>
> No, that you key off kernel/user boundary transitions. Arguably one
> could allow simply system calls and page-faults to happen without
> restarting the tick, then again, RCU is very pervasive these days so I'm
> not quite sure you can actually make that happen.
>

For an example of a per-cpu flag that is checked on every exit with zero 
additional overhead on the flag clear case, look at TIF_USER_RETURN_NOTIFY.

-- 
error compiling committee.c: too many arguments to function

