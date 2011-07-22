Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab1GVSRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 14:17:01 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:34422 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab1GVSRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 14:17:00 -0400
Date: Fri, 22 Jul 2011 23:46:41 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [patch 11/18] sched: prevent interactions with throttled entities
Message-ID: <20110722181641.GA31322@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20110721164325.231521704@google.com>
 <20110721184757.777916795@google.com>
 <20110722114141.GA29349@linux.vnet.ibm.com>
 <1311335019.27400.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1311335019.27400.30.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-07-22 13:43:39]:

> On Fri, 2011-07-22 at 17:11 +0530, Kamalesh Babulal wrote:
> > >                */
> > > -             if (!busiest_cfs_rq->task_weight)
> > > +             if (!busiest_cfs_rq->task_weight ||
> > > +                 throttled_lb_pair(tg, busiest_cpu, this_cpu))
> > 
> > tip commit 9763b67fb9f30 removes both tg and busiest_cpu from
> > load_balance_fair. 
> 
> Grrr, one more untrimmed email and you're in the /dev/null filter.

Sorry, will take care of it next time.

