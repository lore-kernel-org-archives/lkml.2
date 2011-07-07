Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1GGGI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 02:08:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:37838 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab1GGGIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 02:08:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,491,1304319600"; 
   d="scan'208";a="24320718"
Subject: Re: [PATCH 3/3]Subject: CFQ: add think time check for group
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <20110706150628.GD27302@redhat.com>
References: <1309757796.15392.239.camel@sli10-conroe>
	 <20110705143144.GC24348@redhat.com>
	 <1309917520.15392.246.camel@sli10-conroe>
	 <20110706150628.GD27302@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 14:08:21 +0800
Message-ID: <1310018901.15392.249.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-06 at 23:06 +0800, Vivek Goyal wrote:
> On Wed, Jul 06, 2011 at 09:58:40AM +0800, Shaohua Li wrote:
> [..]
> > > > [global]
> > > > runtime=30
> > > > direct=1
> > > > 
> > > > [test1]
> > > > cgroup=test1
> > > > cgroup_weight=1000
> > > > rw=randread
> > > > ioengine=libaio
> > > > size=500m
> > > > runtime=30
> > > > directory=/mnt
> > > > filename=file1
> > > > thinktime=9000
> > > > 
> > > > [test2]
> > > > cgroup=test2
> > > > cgroup_weight=1000
> > > > rw=randread
> > > > ioengine=libaio
> > > > size=500m
> > > > runtime=30
> > > > directory=/mnt
> > > > filename=file2
> > > > 
> > > > 	patched		base
> > > > test1	64k		39k
> > > > test2	540k		540k
> > > > total	604k		578k
> > > > 
> > > > group1 gets much better throughput because it waits less time.
> 
> I don't understand it. Thinktime of group test1 is more than 8ms. So now
> we should not be idling on test1. Hence test1 should lose some share and
> test2 should gain disk share and overall throughput should go up.
> 
> I am wondering why throughput of test2 did not go up?
hmm, actually the throughput of test2 is better. Maybe I wrote it down wrong.
test2 throughput is about 548k/s. Sorry.

> Also can you run some tests to make sure that disk shares of regular
> workloads (thinktime less than 8ms) are not impacted.
I tried think time 2ms or no think time. there is no difference. the
result is quite stable.

Thanks,
Shaohua

