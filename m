Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966766Ab0GSUzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 16:55:19 -0400
Received: from smtp-out.google.com ([74.125.121.35]:12831 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966417Ab0GSUzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 16:55:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=OOsA8nGIH3lUyQ35oR2+ekwcWzI0C6CR3PRr4GxjU/TWpahNBSriASZmQQnoNmsgf
	yK/Pd66wBEjDdeKgcas8g==
MIME-Version: 1.0
In-Reply-To: <1279559652-2775-3-git-send-email-vgoyal@redhat.com>
References: <1279559652-2775-1-git-send-email-vgoyal@redhat.com> 
	<1279559652-2775-3-git-send-email-vgoyal@redhat.com>
From: Divyesh Shah <dpshah@google.com>
Date: Mon, 19 Jul 2010 13:54:53 -0700
Message-ID: <AANLkTil2A2y5f1jrMlAwN3r33TPsVBY3_NHTRlcbmX0F@mail.gmail.com>
Subject: Re: [PATCH 2/3] cfq-iosched: Implement a new tunable group_idle
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@kernel.dk, nauman@google.com,
        guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, czoccolo@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 10:14 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> @@ -3420,7 +3453,10 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>                 * the queue.
>                 */
>                if (cfq_should_wait_busy(cfqd, cfqq)) {
> -                       cfqq->slice_end = jiffies + cfqd->cfq_slice_idle;
> +                       unsigned long extend_sl = cfqd->cfq_slice_idle;
> +                       if (!cfqd->cfq_slice_idle)
> +                               extend_sl = cfqd->cfq_group_idle;
> +                       cfqq->slice_end = jiffies + extend_sl;
>                        cfq_mark_cfqq_wait_busy(cfqq);
>                        cfq_log_cfqq(cfqd, cfqq, "will busy wait");
>                }

Vivek, I haven't looked at this particular code snippet for some time.
Can you tell me why we add the slice_idle (or w/ your change
extend_sl) to slice_end instead of arming the idle timer with that
amount of time?

-Divyesh
