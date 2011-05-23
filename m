Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab1EWCKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 22:10:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:55345 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab1EWCKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 22:10:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,254,1304319600"; 
   d="scan'208";a="2788750"
Subject: Re: [PATCH] block: call elv_bio_merged() when merged
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Divyesh Shah <dpshah@google.com>
In-Reply-To: <4DD6B807.6040309@kernel.dk>
References: <1305869337-4375-1-git-send-email-namhyung@gmail.com>
	 <BANLkTik5Od9tLg1F6mDFkzpViXR2ZcRmgA@mail.gmail.com>
	 <1305885108.1633.11.camel@leonhard>  <4DD6B807.6040309@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 10:10:01 +0800
Message-ID: <1306116601.2375.120.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-21 at 02:50 +0800, Jens Axboe wrote:
> On 2011-05-20 11:51, Namhyung Kim wrote:
> > Hello,
> > 
> > 2011-05-20 (금), 16:31 +0800, Shaohua Li:
> >> 2011/5/20 Namhyung Kim <namhyung@gmail.com>:
> >>> Commit 73c101011926 ("block: initial patch for on-stack per-task plugging")
> >>> removed calls to elv_bio_merged() when @bio merged with @req. Re-add them.
> >>>
> >>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> >>> Cc: Divyesh Shah <dpshah@google.com>
> >>> ---
> >>>  block/blk-core.c |    2 ++
> >>>  1 files changed, 2 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/block/blk-core.c b/block/blk-core.c
> >>> index 3fe00a14822a..4dc02ef5fc82 100644
> >>> --- a/block/blk-core.c
> >>> +++ b/block/blk-core.c
> >>> @@ -1132,6 +1132,7 @@ static bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
> >>>        req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
> >>>
> >>>        drive_stat_acct(req, 0);
> >>> +       elv_bio_merged(q, req, bio);
> >>>        return true;
> >>>  }
> >>>
> >>> @@ -1173,6 +1174,7 @@ static bool bio_attempt_front_merge(struct request_queue *q,
> >>>        req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
> >>>
> >>>        drive_stat_acct(req, 0);
> >>> +       elv_bio_merged(q, req, bio);
> >>>        return true;
> >>>  }
> >> Looks you should do this in __make_request. when the routine is called
> >> in attempt_plug_merge, the request isn't added to elevator yet.
> >>
> > 
> > Hmm.. anyway it is merged. Is there any reason why we shouldn't collect
> > the stat - or invoke the callback routine - if the @req is not in the
> > elevator? Or we need to add a separate stat item for this case?
> 
> Your patch should be safe, it's essentially only for the cgroup stuff
> that does its own accounting and has appropriate protection for it. 
I'm just worrying about there is duplicate accounting, but anyway it's
safe.

