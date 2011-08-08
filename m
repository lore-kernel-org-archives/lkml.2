Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab1HHPqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:46:17 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59700 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1HHPqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:46:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110721184757.480608533@google.com>
References: <20110721164325.231521704@google.com>
	<20110721184757.480608533@google.com>
Date: Mon, 8 Aug 2011 23:46:15 +0800
Message-ID: <CAF1ivSYuYjNXsfCfUj6+rRVQFc1m2EBP3dvtxoo8wJM_EWNtZQ@mail.gmail.com>
Subject: Re: [patch 08/18] sched: add support for throttling group entities
From: Lin Ming <minggr@gmail.com>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 12:43 AM, Paul Turner <pjt@google.com> wrote:

> +static __used void throttle_cfs_rq(struct cfs_rq *cfs_rq)
> +{
> +       struct rq *rq = rq_of(cfs_rq);
> +       struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(cfs_rq->tg);
> +       struct sched_entity *se;
> +       long task_delta, dequeue = 1;
> +
> +       se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
> +
> +       /* account load preceding throttle */
> +       update_cfs_load(cfs_rq, 0);
> +
> +       task_delta = cfs_rq->h_nr_running;
> +       for_each_sched_entity(se) {
> +               struct cfs_rq *qcfs_rq = cfs_rq_of(se);
> +               /* throttled entity or throttle-on-deactivate */
> +               if (!se->on_rq)
> +                       break;

Does it mean it's possible that child se is unthrottled but parent se
is throttled?

I thought if parent group was throttled then its children should be
throttled too.
I may misunderstood the code, please correct me then.

Thanks,
Lin Ming
