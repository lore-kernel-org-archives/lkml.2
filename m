Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1I1OTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:19:52 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47015 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab1I1OTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:19:51 -0400
Date: Wed, 28 Sep 2011 19:47:01 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Venki Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sched: fix nohz idle load balancer issues
Message-ID: <20110928141701.GF8593@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110926115049.GA22604@linux.vnet.ibm.com>
 <CABeCy1YXKR89_uQm_XAyNJHPHkL+6JKxa-C+8Z_9ox7b_k2scQ@mail.gmail.com>
 <20110928043427.GI4357@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110928043427.GI4357@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> [2011-09-28 10:04:27]:

> > Especially with higher number of logical CPUs. Likely cleaner way is to clear
> > first_pick, second_pick on idle instead of clearing on tickless.
> 
> I think I tried that (cleared first/second_pick_cpu in
> nohz_kick_needed() upon idle) but didn't get the best results. Let me
> try that again and post idle time numbers.

So made some changes so that first/second_pick_cpu identifiers are
cleared when corresponding cpus become idle. They are cleared in
pick_next_task_idle() ..

With that change, I don't see additional benefit of having a third busy
cpu kick ilb_cpu when it has > 1 task.


Idle time -> 			Avg.	Std.Dev   Min   Max
W/o third busy cpu kicking	4.57%   0.9	  3%    8%   
With third busy cpu kicking	4.78%   1.1%      3%    8%

So will go with your suggestion in the next version!

- vatsa
