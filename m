Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab1EXRcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:32:41 -0400
Received: from smtp-out.google.com ([74.125.121.67]:9497 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab1EXRck convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:32:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TIYiuUtABvOOaGxEL8ml17sR0aPsdQcFM/g9pjxu2i3PHYQ+6/DAFnch3zC7US4Ig7
         RUhIFE/Xc0stadelE5cA==
MIME-Version: 1.0
In-Reply-To: <1306207131-2296-3-git-send-email-namhyung@gmail.com>
References: <1306207131-2296-1-git-send-email-namhyung@gmail.com> <1306207131-2296-3-git-send-email-namhyung@gmail.com>
From: Justin TerAvest <teravest@google.com>
Date: Tue, 24 May 2011 10:32:06 -0700
Message-ID: <BANLkTikzvWyykGz7_Ob8zJAJFGBvRywp1g@mail.gmail.com>
Subject: Re: [PATCH 3/4] cfq-iosched: remove unused 'group_changed' in cfq_service_tree_add()
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Reviewed-by: Justin TerAvest <teravest@google.com>

On Mon, May 23, 2011 at 8:18 PM, Namhyung Kim <namhyung@gmail.com> wrote:
> The 'group_changed' variable is initialized to 0 and never changed, so
> checking the variable is meaningless.
>
> It is a leftover from 0bbfeb832042 ("cfq-iosched: Always provide group
> iosolation."). Let's get rid of it.
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Justin TerAvest <teravest@google.com>
> ---
>  block/cfq-iosched.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index a79e62063144..4ceebd346710 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1206,7 +1206,6 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>        struct cfq_rb_root *service_tree;
>        int left;
>        int new_cfqq = 1;
> -       int group_changed = 0;
>
>        service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
>                                                cfqq_type(cfqq));
> @@ -1277,7 +1276,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>        rb_link_node(&cfqq->rb_node, parent, p);
>        rb_insert_color(&cfqq->rb_node, &service_tree->rb);
>        service_tree->count++;
> -       if ((add_front || !new_cfqq) && !group_changed)
> +       if (add_front || !new_cfqq)
>                return;
>        cfq_group_notify_queue_add(cfqd, cfqq->cfqg);
>  }
> --
> 1.7.5.2
>
>
