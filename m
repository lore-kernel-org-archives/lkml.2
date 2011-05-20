Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934926Ab1ETIb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:31:59 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48361 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934559Ab1ETIb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:31:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=l3JvSpGRuO/X7m+OzC/LOUf/mDD2sHZHDxzt3Y14DGlUQIaupFo0AKqc1JUzHsA0dH
         b8vwX3LbP8B2lJb92AWNU8eLw1igsIcLJV4Y8xC7F5hg932M/GcsVxIcKSuynva8EXn7
         7W88RKGYKBIWBKG7NazijIP8XiIYm7QvEDi3U=
MIME-Version: 1.0
In-Reply-To: <1305869337-4375-1-git-send-email-namhyung@gmail.com>
References: <1305869337-4375-1-git-send-email-namhyung@gmail.com>
Date: Fri, 20 May 2011 16:31:56 +0800
X-Google-Sender-Auth: yYXGoFGZlNoGMilNX8dTZ8907b4
Message-ID: <BANLkTik5Od9tLg1F6mDFkzpViXR2ZcRmgA@mail.gmail.com>
Subject: Re: [PATCH] block: call elv_bio_merged() when merged
From: Shaohua Li <shaohua.li@intel.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Divyesh Shah <dpshah@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/20 Namhyung Kim <namhyung@gmail.com>:
> Commit 73c101011926 ("block: initial patch for on-stack per-task plugging")
> removed calls to elv_bio_merged() when @bio merged with @req. Re-add them.
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Divyesh Shah <dpshah@google.com>
> ---
>  block/blk-core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3fe00a14822a..4dc02ef5fc82 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1132,6 +1132,7 @@ static bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
>        req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
>
>        drive_stat_acct(req, 0);
> +       elv_bio_merged(q, req, bio);
>        return true;
>  }
>
> @@ -1173,6 +1174,7 @@ static bool bio_attempt_front_merge(struct request_queue *q,
>        req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
>
>        drive_stat_acct(req, 0);
> +       elv_bio_merged(q, req, bio);
>        return true;
>  }
Looks you should do this in __make_request. when the routine is called
in attempt_plug_merge, the request isn't added to elevator yet.

Thanks,
Shaohua
