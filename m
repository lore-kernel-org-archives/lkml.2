Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab1JKOIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:08:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49666 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1JKOIe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:08:34 -0400
Subject: Re: [patch] cpusets, cgroups: disallow attaching kthreadd
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tejun Heo <htejun@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 11 Oct 2011 16:08:07 +0200
In-Reply-To: <20111010164339.GA8100@google.com>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	 <1316770936.6641.11.camel@marge.simson.net>
	 <1316775204.7562.9.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	 <1316788392.6544.33.camel@marge.simson.net>
	 <1318224892.6161.45.camel@marge.simson.net>
	 <1318233815.6527.5.camel@marge.simson.net>
	 <20111010164339.GA8100@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318342087.14615.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 09:43 -0700, Tejun Heo wrote:

> Yes, I think we need something like this.  wq workers were using
> PF_THREAD_BOUND to prevent diddling from userland which made some
> unhappy. 

But that can be properly fixed.

>  Maybe we need a flag to properly indicate "don't diddle with
> this thread from userland"?  But, then, mainline kernel wouldn't need
> the current PF_THREAD_BOUND at all.  Peter, Steven, what do you think?

Strict per-cpu affinity that is needed for correctness and disallows
sched_setaffinity() is something entirely different from not being
allowed to put something in a cgroup.

As to not allowing to put in a cgroup thing, is there anything other
than kthreadd for which we need to enforce that? So far I've mostly
treated it like: root can do stupid things, this is one of them, don't
do that then.

I don't think its horribly bad to change the affinity mask of kthreadd,
if a sibling kthread needs a specific affinity it should set that and
override whatever it inherits. If it runs with the default, its a neat
way of setting that.


