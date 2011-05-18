Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab1ERJLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 05:11:40 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47703 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab1ERJLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 05:11:39 -0400
Message-ID: <4DD38D47.9010505@kernel.dk>
Date: Wed, 18 May 2011 11:11:35 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]block: don't delay blk_run_queue_async
References: <1305708151.2375.115.camel@sli10-conroe>
In-Reply-To: <1305708151.2375.115.camel@sli10-conroe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-18 10:42, Shaohua Li wrote:
> Let's check a scenario:
> 1. blk_delay_queue(q, SCSI_QUEUE_DELAY);
> 2. blk_run_queue_async();
> the second one will became a noop, because q->delay_work already has
> WORK_STRUCT_PENDING_BIT set, so the delayed work will still run after
> SCSI_QUEUE_DELAY. But blk_run_queue_async actually hopes the delayed
> work runs immediately.

Good catch. I wonder if it wouldn't be better to "fix"
queue_delayed_work() instead. If the time passed in is before the
scheduled event, adjust the timeout.

But as a 2.6.39 fix, this is good, will queue up.

-- 
Jens Axboe

