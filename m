Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab1IGQVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:21:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:4776 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366Ab1IGQVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:21:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,345,1312182000"; 
   d="scan'208";a="48885082"
Subject: Re: 3.0.3 kernel BUG at kernel/timer.c:1035
From: Lin Ming <ming.m.lin@intel.com>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110907102425.GA3423@janus>
References: <20110824130238.GA24543@janus>
	 <20110902011058.c5bad476.akpm@linux-foundation.org>
	 <20110905123813.GA29763@janus>
	 <CAF1ivSYui_=tHbxHiy15a9wfiphHcpoY+J1MmAJ=dMQsAfEVLw@mail.gmail.com>
	 <1315320518.4235.3.camel@hp6530s>  <20110907102425.GA3423@janus>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 07 Sep 2011 20:36:19 +0800
Message-ID: <1315398979.2938.0.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 18:24 +0800, Frank van Maarseveen wrote:
> On Tue, Sep 06, 2011 at 10:48:38PM +0800, Lin Ming wrote:
> > Does below patch help?
> > 
> > >From a98b874437f871d5ecc3f6fe409b2b474b1f2731 Mon Sep 17 00:00:00 2001
> > From: Lin Ming <ming.m.lin@intel.com>
> > Date: Tue, 6 Sep 2011 22:45:43 +0800
> > Subject: [PATCH] block: delete bdi writeback wakup_timer in blk_cleanup_queue()
> > 
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  block/blk-core.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 90e1ffd..22529a3 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -363,6 +363,7 @@ void blk_cleanup_queue(struct request_queue *q)
> >  	blk_sync_queue(q);
> >  
> >  	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
> > +	del_timer_sync(&q->backing_dev_info.wb.wakeup_timer);
> >  	mutex_lock(&q->sysfs_lock);
> >  	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
> >  	mutex_unlock(&q->sysfs_lock);
> > -- 
> > 1.7.2.3
> > 
> 
> No, bug still present. Stack trace is the same and I double checked that
> it was the new kernel (this time with a lot more debug enabled).

Thanks for test.
I'll try to reproduce this bug.

Lin Ming


