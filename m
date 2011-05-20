Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934911Ab1ETJv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:51:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40005 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab1ETJvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ihFxNSSXhk40QYI/rTYoB70Jng/zSD3H9iDh2CntyzZJTJx+RwIMvpCg2A03i1mvzp
         pBX3zSeQkBYefonZuwWjuyPSBIFxsJqjovw/cC5/7sfAr64l58TEnxc86g5aM5knQHTy
         DXCgpE1YMFl4m2DV22SFn9hEA0uUACglJC5WY=
Subject: Re: [PATCH] block: call elv_bio_merged() when merged
From: Namhyung Kim <namhyung@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Divyesh Shah <dpshah@google.com>
In-Reply-To: <BANLkTik5Od9tLg1F6mDFkzpViXR2ZcRmgA@mail.gmail.com>
References: <1305869337-4375-1-git-send-email-namhyung@gmail.com>
	 <BANLkTik5Od9tLg1F6mDFkzpViXR2ZcRmgA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 18:51:48 +0900
Message-ID: <1305885108.1633.11.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2011-05-20 (금), 16:31 +0800, Shaohua Li:
> 2011/5/20 Namhyung Kim <namhyung@gmail.com>:
> > Commit 73c101011926 ("block: initial patch for on-stack per-task plugging")
> > removed calls to elv_bio_merged() when @bio merged with @req. Re-add them.
> >
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > Cc: Divyesh Shah <dpshah@google.com>
> > ---
> >  block/blk-core.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> >
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 3fe00a14822a..4dc02ef5fc82 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -1132,6 +1132,7 @@ static bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
> >        req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
> >
> >        drive_stat_acct(req, 0);
> > +       elv_bio_merged(q, req, bio);
> >        return true;
> >  }
> >
> > @@ -1173,6 +1174,7 @@ static bool bio_attempt_front_merge(struct request_queue *q,
> >        req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
> >
> >        drive_stat_acct(req, 0);
> > +       elv_bio_merged(q, req, bio);
> >        return true;
> >  }
> Looks you should do this in __make_request. when the routine is called
> in attempt_plug_merge, the request isn't added to elevator yet.
> 

Hmm.. anyway it is merged. Is there any reason why we shouldn't collect
the stat - or invoke the callback routine - if the @req is not in the
elevator? Or we need to add a separate stat item for this case?

Thanks.

-- 
Regards,
Namhyung Kim


