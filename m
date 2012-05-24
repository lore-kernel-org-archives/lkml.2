Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965709Ab2EXVl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:41:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64902 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965549Ab2EXVl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:41:26 -0400
MIME-Version: 1.0
In-Reply-To: <20120524185919.GE27550@redhat.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
	<1337817771-25038-5-git-send-email-koverstreet@google.com>
	<20120524185919.GE27550@redhat.com>
Date: Thu, 24 May 2012 14:41:24 -0700
X-Google-Sender-Auth: DbnVZFMjBwtaAVggsyKHwPvrtP0
Message-ID: <CAC-hyiHNFSiqPAoe9ynokUg1xTS=V32JDYiVHh_qH7ow=0C1fw@mail.gmail.com>
Subject: Re: [PATCH v2 04/14] block: Add bio_clone_kmalloc()
From: Yehuda Sadeh <yehuda@inktank.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, mpatocka@redhat.com, sage@newdream.net,
        Alex Elder <elder@inktank.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:59 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, May 23, 2012 at 05:02:41PM -0700, Kent Overstreet wrote:
>
> [..]
>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>> index 013c7a5..5a953c6 100644
>> --- a/drivers/block/rbd.c
>> +++ b/drivers/block/rbd.c
>> @@ -729,7 +729,7 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
>>       }
>>
>>       while (old_chain && (total < len)) {
>> -             tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
>> +             tmp = bio_clone_kmalloc(old_chain, gfpmask);
>>               if (!tmp)
>>                       goto err_out;
>>
>> @@ -751,13 +751,9 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
>>                       if (!bp)
>>                               goto err_out;
>>
>> -                     __bio_clone(tmp, &bp->bio1);
>> -
>>                       *next = &bp->bio2;
>
> Is this code correct. Now original code might clone bio after split and
> new code will clone the original bio itself and not the split one?
>

Yeah, that's wrong.

Yehuda
