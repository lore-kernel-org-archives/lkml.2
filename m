Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab1BYQTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 11:19:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab1BYQTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 11:19:15 -0500
Date: Fri, 25 Feb 2011 11:19:05 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dominik Klein <dk@in-telegence.net>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
Message-ID: <20110225161905.GG2994@redhat.com>
References: <20110224151701.GQ7840@htj.dyndns.org>
 <4D67591F.10105@in-telegence.net>
 <20110225112936.GH24828@htj.dyndns.org>
 <4D679688.7020503@in-telegence.net>
 <20110225131850.GI24828@htj.dyndns.org>
 <20110225145708.GB2994@redhat.com>
 <20110225150329.GM24828@htj.dyndns.org>
 <20110225151113.GD2994@redhat.com>
 <20110225160353.GF2994@redhat.com>
 <20110225160903.GR24828@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225160903.GR24828@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 05:09:03PM +0100, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 25, 2011 at 11:03:53AM -0500, Vivek Goyal wrote:
> > +int kthrotld_schedule_delayed_work(struct throtl_data *td,
> > +			struct delayed_work *dwork, unsigned long delay)
> > +{
> > +	return queue_delayed_work(kthrotld_workqueue, dwork, delay);
> > +}
> > +
> 
> I don't think wrapping is necessary.  Defining and using a workqueue
> directly should be enough.
> 
> > @@ -1113,6 +1120,11 @@ void blk_throtl_exit(struct request_queu
> >  
> >  static int __init throtl_init(void)
> >  {
> > +	kthrotld_workqueue = alloc_workqueue("kthrotld",
> > +				WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
> 
> And I don't think kthrotld needs to be HIGHPRI.

Ok, regenerating the patch with above change. Anyway I had to as I 
generated this patch on top of some of my local commits which are
not in Linus tree yet.

Thanks
Vivek
