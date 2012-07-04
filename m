Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2GDTsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 15:48:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:45677 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab2GDTsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 15:48:18 -0400
Subject: Re: [PATCH 09/16] sched: normalize tg load contributions against
 runnable time
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
In-Reply-To: <20120628022414.30496.11931.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
	 <20120628022414.30496.11931.stgit@kitami.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 21:48:05 +0200
Message-ID: <1341431285.19870.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 19:24 -0700, Paul Turner wrote:
> Entities of equal weight should receive equitable distribution of cpu time.
> This is challenging in the case of a task_group's shares as execution may be
> occurring on multiple cpus simultaneously.
> 
> To handle this we divide up the shares into weights proportionate with the load
> on each cfs_rq.  This does not however, account for the fact that the sum of
> the parts may be less than one cpu and so we need to normalize:
>   load(tg) = min(runnable_avg(tg), 1) * tg->shares
> Where runnable_avg is the aggregate time in which the task_group had runnable
> children. 

I remember we had a bit of a discussion on this last time, I thought you
were going to convince me this approximation was 'right'.

Care to still do so.. the rationale used should at least live in a
comment somewhere, otherwise someone will go silly trying to understand
things later on.

