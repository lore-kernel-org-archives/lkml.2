Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1AXTnC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:43:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49620 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1AXTnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:43:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=X3nT33aF3QmZPB73pfY656Pp+dMQx+NmJgbRcVJS2sNdtN/11fGWyUR/1p/oQqx7wN
         C5A/2/bsCyZ2q3ZVj8vb1zsgYdyF5cMZ8pCetlUxn42h/RwNzy0nn7C8k+RyhmD/ykGh
         7lIk5Vy/u4n6opo8+/Qcgv6AhkQ1gGmkG12yc=
MIME-Version: 1.0
In-Reply-To: <1295800203-9552-1-git-send-email-ralf.thielow@googlemail.com>
References: <1295800203-9552-1-git-send-email-ralf.thielow@googlemail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 24 Jan 2011 20:42:36 +0100
X-Google-Sender-Auth: yf7a6DjpVgoL_1yI3JKNNUtalM4
Message-ID: <AANLkTimLbkqmkijkLk+kALOUK6TVB0AJA3Ca+X-wcjpQ@mail.gmail.com>
Subject: Re: [PATCH] infiniband: hw: amso1100: Fixed compile warning.
To: Ralf Thielow <ralf.thielow@googlemail.com>
Cc: tom@opengridcomputing.com, swise@opengridcomputing.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 5:30 PM, Ralf Thielow
<ralf.thielow@googlemail.com> wrote:
>
> Fixed compile warning by use "unsigned long" instead of "u64"
> on assign NULL to "c2_vq_req->reply_msg".
>
> Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
> ---
>  drivers/infiniband/hw/amso1100/c2_vq.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/hw/amso1100/c2_vq.c b/drivers/infiniband/hw/amso1100/c2_vq.c
> index 9ce7819..807b730 100644
> --- a/drivers/infiniband/hw/amso1100/c2_vq.c
> +++ b/drivers/infiniband/hw/amso1100/c2_vq.c
> @@ -107,7 +107,7 @@ struct c2_vq_req *vq_req_alloc(struct c2_dev *c2dev)
>        r = kmalloc(sizeof(struct c2_vq_req), GFP_KERNEL);
>        if (r) {
>                init_waitqueue_head(&r->wait_object);
> -               r->reply_msg = (u64) NULL;
> +               r->reply_msg = (unsigned long) NULL;
>                r->event = 0;
>                r->cm_id = NULL;
>                r->qp = NULL;
> @@ -123,7 +123,7 @@ struct c2_vq_req *vq_req_alloc(struct c2_dev *c2dev)
>  */
>  void vq_req_free(struct c2_dev *c2dev, struct c2_vq_req *r)
>  {
> -       r->reply_msg = (u64) NULL;
> +       r->reply_msg = (unsigned long) NULL;
>        if (atomic_dec_and_test(&r->refcnt)) {
>                kfree(r);
>        }
> @@ -151,7 +151,7 @@ void vq_req_get(struct c2_dev *c2dev, struct c2_vq_req *r)
>  void vq_req_put(struct c2_dev *c2dev, struct c2_vq_req *r)
>  {
>        if (atomic_dec_and_test(&r->refcnt)) {
> -               if (r->reply_msg != (u64) NULL)
> +               if (r->reply_msg != (unsigned long) NULL)
>                        vq_repbuf_free(c2dev,
>                                       (void *) (unsigned long) r->reply_msg);
>                kfree(r);

Hello Ralf,

Have you considered using "0" instead of "(u64) NULL" or "(unsigned
long) NULL" ?

Bart.
