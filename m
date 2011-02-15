Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1BOOf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:35:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211Ab1BOOf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:35:26 -0500
Date: Tue, 15 Feb 2011 09:27:52 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 5/6 v4] cfq-iosched: CFQ group hierarchical scheduling
 and use_hierarchy interface
Message-ID: <20110215142752.GC27296@redhat.com>
References: <4D51ED26.8050809@cn.fujitsu.com>
 <4D539821.1090703@cn.fujitsu.com>
 <20110210205722.GB2600@redhat.com>
 <4D55EEBB.8060304@cn.fujitsu.com>
 <20110214180428.GF13097@redhat.com>
 <4D59E728.3030209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D59E728.3030209@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 10:38:32AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > On Sat, Feb 12, 2011 at 10:21:47AM +0800, Gui Jianfeng wrote:
> > [..]
> >>>> +static struct cfq_group *
> >>>> +cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
> >>>> +{
> >>>> +	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
> >>>> +	struct cfq_group *cfqg = NULL;
> >>>> +	void *key = cfqd;
> >>>> +	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
> >>>> +	unsigned int major, minor;
> >>>> +
> >>>> +	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
> >>>> +	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
> >>>> +		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> >>>> +		cfqg->blkg.dev = MKDEV(major, minor);
> >>>> +		goto done;
> >>>> +	}
> >>> Should we make this updation of this info hierarhical?
> >> IMHO, it's fine to defer the updation when we really get the cfqg.
> > 
> > But if cfqg is alrady present, we will never hit the allocation path 
> > again. So if somebody creates 2-3 level deep hierarchy and does IO
> > only in the children cgroup, parent cgroups will potentially not get
> > device info updated hence no visible stats?
> 
> Ahh, I see your concern. But do we really need to show the stats even if
> a cgroup doesn't issue any IO on a given device? 

I am assuming that once use_hierarchy=1, you are aggregating the stats
in parent cgroups? So if a child services 5 IOs, these are accounted
to parent group also when user_hier=1?

What happens in case of  memoy cgroup controller?

Thanks
Vivek
