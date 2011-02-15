Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1BOPDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:03:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab1BOPDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:03:49 -0500
Date: Tue, 15 Feb 2011 09:21:50 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Justin TerAvest <teravest@google.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 3/6 v4] cfq-iosched: Introduce vdisktime and io weight
 for CFQ queue
Message-ID: <20110215142149.GA27296@redhat.com>
References: <4D51ED26.8050809@cn.fujitsu.com>
 <4D539804.9090308@cn.fujitsu.com>
 <AANLkTimi=7_CEJy2m6Dhcy-aszXKBBL0fbC8mbD9JLOP@mail.gmail.com>
 <4D59DA8C.9020108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D59DA8C.9020108@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 09:44:44AM +0800, Gui Jianfeng wrote:

[..]
> >> +static inline u64 cfq_get_boost(struct cfq_data *cfqd,
> >> +                                struct cfq_queue *cfqq)
> >> +{
> >> +       u64 d;
> >> +
> >> +       if (cfq_cfqq_sync(cfqq))
> >> +               d = CFQ_BOOST_SYNC_BASE << CFQ_SERVICE_SHIFT;
> >> +       else
> >> +               d = CFQ_BOOST_ASYNC_BASE << CFQ_SERVICE_SHIFT;
> >> +
> >> +       d = d * BLKIO_WEIGHT_DEFAULT;
> >> +       do_div(d, cfqq->cfqe.weight);
> >> +       return d;
> >> +}
> > 
> > The logic for cfq_get_boost() looks a lot like cfq_scale_slice().
> > Instead of duplicating code, can't it just be
> > u64 d;
> > if (cfq_cfqq_sync(cfqq))
> >         return cfq_scale_slice(CFQ_BOOST_SYNC_BASE, cfqq->cfqe);
> > else
> >         return cfq_scale_slice(CFQ_BOOST_ASYNC_BASE, cfqq->cfqe);
> > 

I still think that we should use smaller values for CFQ_BOOST_SYNC_BASE
because otherwise what it means is that for freshly backlogged queues
we assume that these have already used one slice and then requeue these
accordingly. Instead it should be reverse where freshly backlogged queues
should get preference over already queues which are hogging the disk
for long time.

Thanks
Vivek 
