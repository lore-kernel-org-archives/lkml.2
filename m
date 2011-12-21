Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab1LURhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:37:22 -0500
Received: from mga12.intel.com ([143.182.124.36]:50609 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752712Ab1LURhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:37:20 -0500
MIME-Version: 1.0
In-Reply-To: <20111221132029.GK20129@parisc-linux.org>
References: <20111220233117.17757.71139.stgit@localhost6.localdomain6>
	<4EF17DC4.5010008@tao.ma>
	<alpine.SOC.1.00.1112210835010.6858@math.ut.ee>
	<4EF18129.7030407@tao.ma>
	<CABE8wwtrq=SuuhAvNDjpSbfPGE+N4cWjjmVGWq8UzaH6sM9kRg@mail.gmail.com>
	<20111221132029.GK20129@parisc-linux.org>
Date: Wed, 21 Dec 2011 09:37:17 -0800
Message-ID: <CABE8wwuO7=Jo2RkrBFgnvuQP2X5UAohP-ZdWg6WejXUe+XRYyA@mail.gmail.com>
Subject: Re: [PATCH] block: fix blk_queue_end_tag()
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Tao Ma <tm@tao.ma>, Meelis Roos <mroos@linux.ee>, axboe@kernel.dk,
        Tao Ma <boyu.mt@taobao.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Ed Nadolski <edmund.nadolski@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 5:20 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Dec 20, 2011 at 11:30:14PM -0800, Williams, Dan J wrote:
>> @@ -284,16 +284,7 @@ void blk_queue_end_tag(struct request_queue *q,
>> struct request *rq)
>>         struct blk_queue_tag *bqt = q->queue_tags;
>>         int tag = rq->tag;
>>
>> -       BUG_ON(tag == -1);
>> -
>> -       if (unlikely(tag >= bqt->max_depth)) {
>> -               /*
>> -                * This can happen after tag depth has been reduced.
>> -                * But tag shouldn't be larger than real_max_depth.
>> -                */
>> -               WARN_ON(tag >= bqt->real_max_depth);
>> -               return;
>> -       }
>> +       BUG_ON(tag == -1 || tag > bqt->real_max_depth);
>
> or ...
>
> -       int tag = rq->tag;
> +       unsigned tag = rq->tag;
> +       BUG_ON(tag >= bqt->real_max_depth);
>
> since tags in the range INT_MIN to -2 are also a bug, right?

Yes, even better... patch coming up.
