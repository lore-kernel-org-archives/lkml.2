Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0G0NJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 09:09:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab0G0NJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 09:09:15 -0400
Date: Tue, 27 Jul 2010 09:09:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, nauman@google.com,
        dpshah@google.com, jmoyer@redhat.com, czoccolo@gmail.com
Subject: Re: [PATCH 2/5] cfq-iosched: Implment IOPS mode for group scheduling
Message-ID: <20100727130906.GA23118@redhat.com>
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
 <1279834172-4227-3-git-send-email-vgoyal@redhat.com>
 <4C4E72FB.2080104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4E72FB.2080104@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 01:47:39PM +0800, Gui Jianfeng wrote:

[..]
> > @@ -913,19 +927,21 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
> >  				struct cfq_queue *cfqq)
> >  {
> >  	struct cfq_rb_root *st = &cfqd->grp_service_tree;
> > -	unsigned int used_sl, charge_sl;
> > +	unsigned int used_sl, charge;
> >  	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg)
> >  			- cfqg->service_tree_idle.count;
> >  
> >  	BUG_ON(nr_sync < 0);
> > -	used_sl = charge_sl = cfq_cfqq_slice_usage(cfqq);
> > +	used_sl = charge = cfq_cfqq_slice_usage(cfqq);
> >  
> > -	if (!cfq_cfqq_sync(cfqq) && !nr_sync)
> > -		charge_sl = cfqq->allocated_slice;
> > +	if (iops_mode(cfqd))
> > +		charge = cfqq->slice_dispatch;
> 
> Hi Vivek,
> 
> At this time, requests may still stay in dispatch list, shall we add a new variable
> in cfqq to keep track of the number of requests that go into driver, and charging
> this number?
> 

Hi Gui,

How does that help. Even if request is in dispatch list, sooner or later
it will be dispatched. As long as we can make sure that requests in 
dispatch list are in proportion to group weights, things should be just
fine.

Thanks
Vivek
