Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1AZSMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:12:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab1AZSMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:12:37 -0500
Subject: Re: [PATCH 16/16] KVM-GST: adjust scheduler cpu power
From: Glauber Costa <glommer@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1296060386.28776.1312.camel@laptop>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
	 <1295892397-11354-17-git-send-email-glommer@redhat.com>
	 <1295893920.28776.468.camel@laptop>
	 <1295895083.15920.9.camel@mothafucka.localdomain>
	 <1295898690.28776.472.camel@laptop>
	 <1295985756.15920.33.camel@mothafucka.localdomain>
	 <1295986386.28776.1101.camel@laptop>
	 <1295988455.15920.35.camel@mothafucka.localdomain>
	 <1295989664.28776.1124.camel@laptop>
	 <1295990853.15920.37.camel@mothafucka.localdomain>
	 <1296035871.28776.1132.camel@laptop>
	 <1296056617.3591.26.camel@mothafucka.localdomain>
	 <1296060386.28776.1312.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Wed, 26 Jan 2011 16:11:56 -0200
Message-ID: <1296065516.3591.31.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 17:46 +0100, Peter Zijlstra wrote:
> On Wed, 2011-01-26 at 13:43 -0200, Glauber Costa wrote:
> 
> > yes, but once this delta is subtracted from rq->clock_task, this value is not
> > used to dictate power, unless I am mistaken.
> > 
> > power is adjusted according to scale_rt_power(), which does it using the
> > values of rq->rt_avg, rq->age_stamp, and rq->clock.
> > 
> > So whatever I store into rq->clock_task, but not rq->clock (which
> > correct me if I'm wrong, is expected to be walltime), will not be used
> > to adjust cpu power, which is what I'm trying to achieve.
> 
> No, see the below, it uses a per-cpu virt_steal_time() clock which is
> expected to return steal-time in ns.
> 
> All time not accounted to ->clock_task is accumulated in lost, and
> passed into sched_rt_avg_update() and thus affects the cpu_power.
> 
> If it finds that 50% of the (recent) time is steal time, its cpu_power
> will be 50%.
ok, now I get your proposal. It does make sense.

