Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab0GVUzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:55:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab0GVUzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:55:01 -0400
Date: Thu, 22 Jul 2010 16:54:47 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
        czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosced: Implement IOPS mode and group_idle
 tunable V3
Message-ID: <20100722205447.GB2688@redhat.com>
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
 <20100722055602.GA18566@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722055602.GA18566@infradead.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 01:56:02AM -0400, Christoph Hellwig wrote:
> On Wed, Jul 21, 2010 at 03:06:18PM -0400, Vivek Goyal wrote:
> > On high end storage (I got on HP EVA storage array with 12 SATA disks in 
> > RAID 5),
> 
> That's actually quite low end storage for a server these days :)
> 
> > So this is not the default mode. This new tunable group_idle, allows one to
> > set slice_idle=0 to disable some of the CFQ features and and use primarily
> > group service differentation feature.
> 
> While this is better than before needing a sysfs tweak to get any
> performance out of any kind of server class hardware still is pretty
> horrible.  And slice_idle=0 is not exactly the most obvious paramter
> I would look for either.    So having some way to automatically disable
> this mode based on hardware characteristics would be really useful,
> and if that's not possible at least make sure it's very obviously
> document and easily found using web searches.
> 
> Btw, what effect does slice_idle=0 with your patches have to single SATA
> disk and single SSD setups?

Well after responding to your mail in the morning, I realized that it was
a twisted answer and not very clear.

That forced me to change the patch a bit. With new patches (yet to be
posted), answer to your question is that nothing will change for SATA
or SSD setup with slice_idle=0 with my patches..

Why? CFQ is using two different algorithms for cfq queue and cfq group
scheduling. This IOPS mode will only affect group scheduling and not
the cfqq scheduling.

So switching to IOPS mode should not change anything for non cgroup users on
all kind of storage. It will impact only group scheduling users who will start
seeing fairness among groups in terms of IOPS and not time. Of course
slice_idle needs to be set to 0 only on high end storage so that we get
fairness among groups in IOPS at the same time achieve full potential of
storage box.

Thanks
Vivek 
