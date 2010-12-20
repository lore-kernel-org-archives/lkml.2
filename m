Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab0LTQGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:06:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52538 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702Ab0LTQGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:06:45 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=0YtosmEAv3sA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=_NJRT24Ztekrb9NQwXEA:9 a=2K_R9xe4Yfpg1O09CSIs5DHWEAgA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC PATCH 02/15] nohz_task: Avoid nohz task cpu as non-idle
 timer target
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <1292860078.5021.6.camel@laptop>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-3-git-send-email-fweisbec@gmail.com>
	 <1292860078.5021.6.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 20 Dec 2010 11:06:42 -0500
Message-ID: <1292861202.22905.23.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 16:47 +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > Unbound timers are preferably targeted for non idle cpu. If
> > possible though, prioritize idle cpus over nohz task cpus,
> > because the main point of nohz task is to avoid unnecessary
> > timer interrupts.
> 
> Oh is it?
> 
> I'd very much expect the cpu that arms the timer to get the interrupt. I
> mean, if the task doesn't want to get interrupted by timers,
> _DON'T_USE_TIMERS_ to begin with.
> 
> So no, don't much like this at all.

I think this comes from other tasks on other CPUs that are using timers.
Although, I'm not sure what causes an "unbound" timer to happen. I
thought timers usually go off on the CPU that asked for it to go off.

-- Steve


