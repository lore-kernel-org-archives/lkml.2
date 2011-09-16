Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1IPHms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 03:42:48 -0400
Received: from smtp-out.google.com ([74.125.121.67]:42769 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab1IPHmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 03:42:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:message-id:date:from:user-agent:
	mime-version:newsgroups:to:cc:subject:references:in-reply-to:
	content-type:content-transfer-encoding:x-system-of-record;
	b=vBGHuJF8VMPFQD37lLQkm9ttOJaM6+Rd/PTtpp8VdpMnbdzST8pvJTPgWnqXAj4EC
	NTJwX5nqAnRlotZNkFMow==
Message-ID: <4E72FDF1.3080608@google.com>
Date: Fri, 16 Sep 2011 00:42:41 -0700
From: Paul Turner <pjt@google.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Wang Xingchao <xingchao.wang@intel.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        yong.zhang0@gmail.com, alex.shi@intel.com
Subject: Re: [PATCH] cfs: NULL pointer check
References: <1316195333-12374-1-git-send-email-xingchao.wang@intel.com>
In-Reply-To: <1316195333-12374-1-git-send-email-xingchao.wang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/11 10:48, Wang Xingchao wrote:
> se maybe NULL if cfs_rq->rb_leftmost is NULL

nack, it had better not be; otherwise we've got a corrupt tree!

Also, this diff is against the previous -- please bundle dependent 
patches as a series in the future.

Thanks,

- Paul


>
> Signed-off-by: Wang Xingchao<xingchao.wang@intel.com>
> ---
>   kernel/sched_fair.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index fef0bfd..109b232 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1130,6 +1130,10 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>   		return;
>
>   	se = __pick_first_entity(cfs_rq);
> +
> +	if (!se)
> +		return;
> +
>   	delta = curr->vruntime - se->vruntime;
>
>   	if (delta<  0)

