Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab2FIRqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 13:46:17 -0400
Received: from relay03ant.iops.be ([212.53.5.218]:38733 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2FIRqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 13:46:15 -0400
Message-ID: <4FD345DC.6020405@acm.org>
Date: Sat, 09 Jun 2012 12:47:24 +0000
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Muthu Kumar <muthu.lkml@gmail.com>
CC: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Jej B <James.Bottomley@hansenpartnership.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH UPDATED] block: In blk_execute_rq_nowait, init rq->end_io
 before checking for dead queue.
References: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com>
In-Reply-To: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/12 00:10, Muthu Kumar wrote:

> Since the queue->lock case is taken care of in the following patch:
> 
> (http://www.spinics.net/lists/linux-scsi/msg59845.html [PATCH 1/4]
> block: Fix race on request_queue.end_io invocations)
> 
> Updated the patch with just the end_io assignment before dead queue check.
> 
> 
> -------------
> blk-exec.c: In blk_execute_rq_nowait(), if the queue is dead, call to
> done() routine is not made. That will result in blk_execute_rq() stuck
> in wait_for_completion(). Avoid this by initializing rq->end_io to
> done() routine before we check for dead queue.
> 
> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
> CC: Tejun Heo <tj@kernel.org>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: James Bottomley <James.Bottomley@hansenpartnership.com>
> 
> -------------
> diff --git a/block/blk-exec.c b/block/blk-exec.c
> index fb2cbd5..f8b00c7 100644
> --- a/block/blk-exec.c
> +++ b/block/blk-exec.c
> @@ -53,6 +53,9 @@ void blk_execute_rq_nowait(struct request_queue *q,
> struct gendisk *bd_disk,
>         WARN_ON(irqs_disabled());
>         spin_lock_irq(q->queue_lock);
> 
> +       rq->rq_disk = bd_disk;
> +       rq->end_io = done;
> +
>         if (unlikely(blk_queue_dead(q))) {
>                 spin_unlock_irq(q->queue_lock);
>                 rq->errors = -ENXIO;
> @@ -61,8 +64,6 @@ void blk_execute_rq_nowait(struct request_queue *q,
> struct gendisk *bd_disk,
>                 return;
>         }


This patch does not apply since it's line-wrapped and a part is missing
in the second hunk. However, if I had overlooked your original patch
then I want to apologize.

If you can resend your original patch including the locking changes then
I'll test it further.

Bart.
