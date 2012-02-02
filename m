Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2BBWrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:47:52 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53194 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab2BBWru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:47:50 -0500
MIME-Version: 1.0
In-Reply-To: <20120202224708.GF1723@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
	<1328131156-13290-10-git-send-email-tj@kernel.org>
	<20120202224708.GF1723@redhat.com>
Date: Thu, 2 Feb 2012 14:47:49 -0800
X-Google-Sender-Auth: 2rDA3gE0zMrHsIfAU_5qQjp3KJM
Message-ID: <CAOS58YOEF9--uruKyXDBOkxCzEP-pojmiz2CF1CD6xLMYu5x_w@mail.gmail.com>
Subject: Re: [PATCH 09/11] blkcg: move per-queue blkg list heads and counters
 to queue and blkg
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 2, 2012 at 2:47 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Feb 01, 2012 at 01:19:14PM -0800, Tejun Heo wrote:
>
> [..]
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index ab0a11b..025ef60 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -546,6 +546,10 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
>>       setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
>>       INIT_LIST_HEAD(&q->timeout_list);
>>       INIT_LIST_HEAD(&q->icq_list);
>> +#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
>
> BLK_CGROUP_MODULE not required as you got rid of this possiblity in the
> first patch itself
>
>>
>>       struct list_head        icq_list;
>> +#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
>
> Ditto.

Ooh, right.  Will remove them.  Thanks.

-- 
tejun
