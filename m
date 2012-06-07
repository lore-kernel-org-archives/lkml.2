Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab2FGFx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 01:53:57 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40481 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab2FGFx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 01:53:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAFR8uedYpEX+9RiK11G-KvcEU7mYrt58OAFWs4mgoUpLQMowTQ@mail.gmail.com>
References: <CAFR8ueeUH-O8+jeZu2Aeyu4ZDHv255a2qqnt0_Af79oY2JGzTw@mail.gmail.com>
	<CAOS58YOf0m5WUcn3b2f_PGr=P+DH1-0EHBy_fHw3xmccHW+zRA@mail.gmail.com>
	<CAFR8uedYpEX+9RiK11G-KvcEU7mYrt58OAFWs4mgoUpLQMowTQ@mail.gmail.com>
Date: Thu, 7 Jun 2012 14:53:24 +0900
X-Google-Sender-Auth: 2drfc4wxO7tEa7sNgHKRHnkH31g
Message-ID: <CAOS58YPAOYcHYkXu7hW-DeGRXkFqoF1cLarJFfh0eNfFaVHyBg@mail.gmail.com>
Subject: Re: [PATCH] blk-exec-assign-endio-before-queue-dead-check
From: Tejun Heo <tj@kernel.org>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 7, 2012 at 2:42 PM, Muthu Kumar <muthu.lkml@gmail.com> wrote:
>>> One more thing to consider is, the completion function is called from
>>> the same calling context here. As far as my check, it looks ok. Let me
>>> know if you think otherwise.
>>
>> Not sure what you mean.
>
> If there is no error, then the completion routine is called in a
> different context - rq completion context. But here, we call the
> completion routine in the same context of the caller.

Ah, okay. I think the only problem there would be that the end_io
callback is being called outside queue lock. Can you please take care
of that too?

> blk-exec.c: In blk_execute_rq_nowait(), if the queue is dead, call to
> done() routine is not made. That will result in blk_execute_rq() stuck
> in wait_for_completion(). Avoid this by initializing rq->end_io to
> done() routine before we check for dead queue.

Yeah, sounds about right.

Thanks.

-- 
tejun
