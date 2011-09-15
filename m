Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1IOBFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 21:05:24 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42242 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab1IOBFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 21:05:23 -0400
MIME-Version: 1.0
In-Reply-To: <1315984992-5158-2-git-send-email-tm@tao.ma>
References: <1315984992-5158-1-git-send-email-tm@tao.ma>
	<1315984992-5158-2-git-send-email-tm@tao.ma>
Date: Thu, 15 Sep 2011 09:05:23 +0800
X-Google-Sender-Auth: bHLjyJ7f1Ljag7cMWpwX8WEfTuE
Message-ID: <CANejiEWa5um5LtRkL3NcbNgBnUCG1Ud8qw-hfXW3X3GPfHv4iQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] block: Don't check QUEUE_FLAG_SAME_COMP in __blk_complete_request.
From: Shaohua Li <shli@kernel.org>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/14 Tao Ma <tm@tao.ma>:
> From: Tao Ma <boyu.mt@taobao.com>
>
> In __blk_complete_request, we check both QUEUE_FLAG_SAME_COMP and req->cpu
> to decide whether we should use req->cpu. Actually the user can also
> select the complete cpu by either setting BIO_CPU_AFFINE or by calling
> bio_set_completion_cpu. Current solution makes these 2 ways don't work
> any more. So we'd better just check req->cpu.
>
> Cc: Jens Axboe <jaxboe@fusionio.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  block/blk-softirq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/block/blk-softirq.c b/block/blk-softirq.c
> index 58340d0..1366a89 100644
> --- a/block/blk-softirq.c
> +++ b/block/blk-softirq.c
> @@ -115,7 +115,7 @@ void __blk_complete_request(struct request *req)
>        /*
>         * Select completion CPU
>         */
> -       if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) && req->cpu != -1) {
> +       if (req->cpu != -1) {
>                ccpu = req->cpu;
>                if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags)) {
>                        ccpu = blk_cpu_to_group(ccpu);
why not delete bio_set_completion_cpu()?
1. nobody uses it in my search
2. it's misleading. even setting the completion cpu, the bio isn't
always to run finish in the cpu,
it's just run in the group of the cpu.

Thanks,
Shaohua
