Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965814Ab2B1RqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:46:21 -0500
Received: from service87.mimecast.com ([91.220.42.44]:34979 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965345Ab2B1RqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:46:20 -0500
Date: Tue, 28 Feb 2012 17:45:59 +0000
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH 1/2] sched: entity load-tracking re-work - Fix for ARM
Message-ID: <20120228174559.GC1129@e103034-lin.cambridge.arm.com>
References: <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
 <1330511859-22032-2-git-send-email-panto@antoniou-consulting.com>
MIME-Version: 1.0
In-Reply-To: <1330511859-22032-2-git-send-email-panto@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Feb 2012 17:46:21.0523 (UTC) FILETIME=[E1E6A230:01CCF640]
X-MC-Unique: 112022817461511301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 10:37:38AM +0000, Pantelis Antoniou wrote:
> @@ -1110,9 +1110,9 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
>  	struct cfs_rq *cfs_rq = group_cfs_rq(se);
>  	struct task_group *tg = cfs_rq->tg;
>  	int runnable_avg;
> +	u64 contrib;
>  
> -	se->avg.load_avg_contrib = (cfs_rq->tg_load_contrib * tg->shares);
> -	se->avg.load_avg_contrib /= atomic64_read(&tg->load_avg) + 1;

It seems that contrib is never assigned?
Fix:
+	contrib = (cfs_rq->tg_load_contrib * tg->shares);

> +	se->avg.load_avg_contrib = div_u64(contrib, atomic64_read(&tg->load_avg) + 1);

Regards,
Morten

