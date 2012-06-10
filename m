Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2FJRtt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 13:49:49 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61231 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2FJRts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 13:49:48 -0400
Date: Sun, 10 Jun 2012 12:49:39 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Doug Smythies <dsmythies@telus.net>
Cc: "'Anders =?utf-8?B?Qm9zdHLDtm0n?=" <anders@netinsight.net>,
        linux-kernel@vger.kernel.org,
        "=?utf-8?Q?'Les=C5=82aw_Kope=C4=87'?=" <leslaw.kopec@nasza-klasa.pl>,
        "'Aman Gupta'" <aman@tmm1.net>,
        "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>,
        "'Thomas Gleixner'" <tglx@linutronix.de>,
        Charles Wang <muming.wq@gmail.com>
Subject: Re: [3.2.16 -> 3.2.17 regression] High reported CPU load when idle
Message-ID: <20120610174939.GA456@burratino>
References: <20120523.144057.899060240318474097.anders@netinsight.net>
 <20120523215359.GA19798@burratino>
 <20120524214516.GB1158@burratino>
 <000c01cd3e70$b651dd10$22f59730$@net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000c01cd3e70$b651dd10$22f59730$@net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug et al,

Doug Smythies wrote:

> "does 556061b00c9f ("sched/nohz: Fix rq->cpu_load[] calculations",
> 2012-05-11) change anything?"
>
> I back edited those changes into my test environment yesterday. It
> made no difference with respect to this issue. (minimally tested.)
[...]
> By the way, I found and tested 5aaa0b7a2ed5b12692c9ffb5222182bd558d3146
> It is similar (minimally tested).
>
> I am certainly not an expert, and I find the load average area of the
> code extremely difficult to follow and understand. That being said, I
> think the root issue here is the 10 tick grace period. I think that
> cpu idle enter exit transitions can not be ignored during this period,
> and somehow needs to be accumulated towards the next sample time. So far,
> I have been unsuccessful trying to help with a suggested solution. I will
> continue to try.

Another load average related patch is being discussed (not meant
particularly to address the too-low load case, just mentioning it
FYI):

	sched: Folding nohz load accounting more accurate

	After patch 453494c3d4 (sched: Fix nohz load accounting -- again!), we can fold
	the idle into calc_load_tasks_idle between the last cpu load calculating and
	calc_global_load calling. However problem still exits between the first cpu 
	load calculating and the last cpu load calculating. Every time when we do load 
	calculating, calc_load_tasks_idle will be added into calc_load_tasks, even if
	the idle load is caused by calculated cpus. This problem is also described in
	the following link:

	https://lkml.org/lkml/2012/5/24/419

	This bug can be found in our work load. The average running processes number 
	is about 15, but the load only shows about 4.

>From [*].

Hope that helps,
Jonathan

[*] http://thread.gmane.org/gmane.linux.kernel/1310462
