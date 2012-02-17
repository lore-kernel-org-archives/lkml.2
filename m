Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2BQEmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 23:42:07 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:60648 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2BQEmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 23:42:04 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 06/14] sched: aggregate total task_group load
In-Reply-To: <20120202013826.20844.94427.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com> <20120202013826.20844.94427.stgit@kitami.mtv.corp.google.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Fri, 17 Feb 2012 10:11:22 +0530
Message-ID: <87y5s2cbrh.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12021704-5564-0000-0000-000001678C60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Feb 2012 17:38:26 -0800, Paul Turner <pjt@google.com> wrote:
> +static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
> +						 int force_update)
> +{
> +	struct task_group *tg = cfs_rq->tg;
> +	s64 tg_contrib;
> +
> +	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
> +	tg_contrib -= cfs_rq->tg_load_contrib;
> +
> +	if (force_update || abs64(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
>
Not obvious to me where this 8 is coming from?

Regards
Nikunj

