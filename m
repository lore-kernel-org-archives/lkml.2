Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1ARArg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 19:47:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:24458 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab1ARAre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 19:47:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,336,1291622400"; 
   d="scan'208";a="375888519"
Subject: Re: [PATCH 2/2]block cfq: compensate preempted queue even if it
 has no slice assigned
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
In-Reply-To: <20110117140648.GB5624@redhat.com>
References: <1294735917.1949.638.camel@sli10-conroe>
	 <20110117140648.GB5624@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 08:47:28 +0800
Message-ID: <1295311648.1949.717.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 22:06 +0800, Vivek Goyal wrote:
> On Tue, Jan 11, 2011 at 04:51:57PM +0800, Shaohua Li wrote:
> > If a queue is preempted before it gets slice assigned, the queue doesn't get
> > compensation, which looks unfair. For such queue, we compensate it for a whole
> > slice.
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > 
> > ---
> >  block/cfq-iosched.c |   19 +++++++++++++++----
> >  1 file changed, 15 insertions(+), 4 deletions(-)
> > 
> > Index: linux/block/cfq-iosched.c
> > ===================================================================
> > --- linux.orig/block/cfq-iosched.c	2011-01-10 15:37:33.000000000 +0800
> > +++ linux/block/cfq-iosched.c	2011-01-10 15:54:28.000000000 +0800
> > @@ -605,8 +605,8 @@ cfq_group_slice(struct cfq_data *cfqd, s
> >  	return cfq_target_latency * cfqg->weight / st->total_weight;
> >  }
> >  
> > -static inline void
> > -cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> > +static inline unsigned
> > +cfq_scaled_group_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> >  {
> 
> Shaohua,
> 
> Above name "cfq_scaled_group_slice()" does not seem appropriate. It sounds
> as if we are calculating scaled group slice length but the fact is we
> are trying to come up with slice length of cfqq. So a better name might
> be cfq_scaled_slice_cfqq() or cfqq_scaled_slice() something like that. 
either is ok to me. can you post a patch to fix it, as the patch is
already merged.

Thanks,
Shaohua

