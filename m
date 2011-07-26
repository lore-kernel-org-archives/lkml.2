Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab1GZGWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:22:49 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56429 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1GZGWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:22:44 -0400
MIME-Version: 1.0
In-Reply-To: <4E2E4FF1.1010103@fusionio.com>
References: <CACVXFVOYYZt-XfbPx_dEOm9qOAuGqmviH4TdXxg6xTrrB8PaMQ@mail.gmail.com>
	<4E2E4FF1.1010103@fusionio.com>
Date: Tue, 26 Jul 2011 14:22:43 +0800
Message-ID: <CACVXFVPK9B65-McHv9HVsmLNZdwfeLbVgYYagpK-ymEK+hC0RQ@mail.gmail.com>
Subject: Re: block: BUG: using smp_processor_id() in preemptible [00000000] code
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 26, 2011 at 1:26 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-07-26 06:49, Ming Lei wrote:
>> Hi,
>>
>> The bug is observed in -next-20110725, follows the stack trace[1], and
>> seems the attachment patch can fix the bug.
>
> Does this work, too? We don't necessarily need the CPU stable, but
> spewing debug output isn't very nice.

This does work, thanks,

> diff --git a/block/blk-core.c b/block/blk-core.c
> index f8cb099..f925581 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1283,7 +1283,7 @@ get_rq:
>
>        if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) ||
>            bio_flagged(bio, BIO_CPU_AFFINE))
> -               req->cpu = smp_processor_id();
> +               req->cpu = raw_smp_processor_id();
>
>        plug = current->plug;
>        if (plug) {
>
> --
> Jens Axboe
>
>


thanks,
-- 
Ming Lei
