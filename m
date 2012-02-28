Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965862Ab2B1RxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:53:04 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:58295 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965392Ab2B1RxC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:53:02 -0500
Subject: Re: [PATCH 1/2] sched: entity load-tracking re-work - Fix for ARM
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20120228174559.GC1129@e103034-lin.cambridge.arm.com>
Date: Tue, 28 Feb 2012 19:52:56 +0200
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <3E8017B2-836A-466A-92F1-E625F49E554D@antoniou-consulting.com>
References: <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com> <1330511859-22032-2-git-send-email-panto@antoniou-consulting.com> <20120228174559.GC1129@e103034-lin.cambridge.arm.com>
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 28, 2012, at 7:45 PM, Morten Rasmussen wrote:

> On Wed, Feb 29, 2012 at 10:37:38AM +0000, Pantelis Antoniou wrote:
>> @@ -1110,9 +1110,9 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
>> 	struct cfs_rq *cfs_rq = group_cfs_rq(se);
>> 	struct task_group *tg = cfs_rq->tg;
>> 	int runnable_avg;
>> +	u64 contrib;
>> 
>> -	se->avg.load_avg_contrib = (cfs_rq->tg_load_contrib * tg->shares);
>> -	se->avg.load_avg_contrib /= atomic64_read(&tg->load_avg) + 1;
> 
> It seems that contrib is never assigned?
> Fix:
> +	contrib = (cfs_rq->tg_load_contrib * tg->shares);
> 
>> +	se->avg.load_avg_contrib = div_u64(contrib, atomic64_read(&tg->load_avg) + 1);
> 
> Regards,
> Morten
> 

Hmm, yeah,

2 line patch and brown paper bag time.

Thanks

-- Pantelis