Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2FGFht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 01:37:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58682 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2FGFhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 01:37:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAFR8ueeUH-O8+jeZu2Aeyu4ZDHv255a2qqnt0_Af79oY2JGzTw@mail.gmail.com>
References: <CAFR8ueeUH-O8+jeZu2Aeyu4ZDHv255a2qqnt0_Af79oY2JGzTw@mail.gmail.com>
Date: Thu, 7 Jun 2012 14:37:47 +0900
X-Google-Sender-Auth: CT_AnsdEIyRAJA9h_Rr2SH2xyCM
Message-ID: <CAOS58YOf0m5WUcn3b2f_PGr=P+DH1-0EHBy_fHw3xmccHW+zRA@mail.gmail.com>
Subject: Re: [PATCH] blk-exec-assign-endio-before-queue-dead-check
From: Tejun Heo <tj@kernel.org>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 7, 2012 at 2:35 PM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
>> Looks like the bug there is rq->rq_disk and rq->end_io assignments
>> happening after the queue_dead check.  Just move the two lines before
>> queue_head check?
>
> Thought about that. But the problem is, original rq->end_io is not
> saved before the new assignment. But exploring further, I guess its ok
> in this use case.

It's supposed to be overridden, so I don't think that matters.

> One more thing to consider is, the completion function is called from
> the same calling context here. As far as my check, it looks ok. Let me
> know if you think otherwise.

Not sure what you mean.

> Anyway, patch attached (as well as inline).
>
> Regards,
> Muthu
>
> -----------------------
> blk-exec.c: In blk_execute_rq_nowait(), assign rq->endio,rq_disk
> before queue dead check.

Needs way more description.

Thanks.

-- 
tejun
