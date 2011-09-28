Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1I1FHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 01:07:06 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47852 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab1I1FHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 01:07:04 -0400
Date: Wed, 28 Sep 2011 10:36:58 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Venki Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sched: fix nohz idle load balancer issues
Message-ID: <20110928050344.GD8593@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20110926115049.GA22604@linux.vnet.ibm.com>
 <CABeCy1YXKR89_uQm_XAyNJHPHkL+6JKxa-C+8Z_9ox7b_k2scQ@mail.gmail.com>
 <20110928043427.GI4357@linux.vnet.ibm.com>
 <20110928043921.GC8593@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110928043921.GC8593@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> [2011-09-28 10:09:21]:

> * Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> [2011-09-28 10:04:27]:
> 
> > unless we want to go for more sophisticated like a sorted list of
> > rq->next_balance in a rb-tree
> 
> Given that this list will need to be global (and not per-cpu) and it will need 
> to be updated reqularly (even when cpus are busy and as they update their 
> rq->next_balance), that will probably not fly!

On third thoughts, this list needs to be updated only in idle cpu
context (idle cpus going tickless will be inserted in the list (indexed at 
rq->next_balance and cpu exiting idle will need to be removed). So the global 
list may not hurt so much ..will see how that comes up in code.

- vatsa
