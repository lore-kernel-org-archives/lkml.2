Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab0DAHXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 03:23:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52843 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab0DAHXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 03:23:46 -0400
Message-ID: <4BB44A15.60306@cn.fujitsu.com>
Date: Thu, 01 Apr 2010 15:24:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: don't call rcu_preempt_note_context_switch() in
 rcu_check_callbacks()
References: <4BB014DF.9030905@cn.fujitsu.com> <20100329044236.GB2343@linux.vnet.ibm.com> <4BB1C7C5.5070700@cn.fujitsu.com> <20100330160339.GB2513@linux.vnet.ibm.com> <20100331153656.GA4623@linux.vnet.ibm.com> <4BB3EF25.1040804@cn.fujitsu.com> <20100401011747.GJ2461@linux.vnet.ibm.com>
In-Reply-To: <20100401011747.GJ2461@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> Possibly by moving the clearing of RCU_READ_UNLOCK_NEED_QS to
> rcu_preempt_check_callbacks() 

current rcu_preempt_check_callbacks() already has code to
clear RCU_READ_UNLOCK_NEED_QS.

> -- or to rcu_preempt_qs().  The latter is in
> some sense cleaner, but higher overhead and probably unnecessary.  Hmmm...
> Alternatively, require that all callers to rcu_preempt_qs() disable
> irqs.  This affects only one callsite, which has a local_irq_disable()
> immediately following anyway.  ;-)
> 
> 							Thanx, Paul

