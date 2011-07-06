Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1GFPGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:06:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab1GFPGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:06:30 -0400
Date: Wed, 6 Jul 2011 11:06:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 3/3]Subject: CFQ: add think time check for group
Message-ID: <20110706150628.GD27302@redhat.com>
References: <1309757796.15392.239.camel@sli10-conroe>
 <20110705143144.GC24348@redhat.com>
 <1309917520.15392.246.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309917520.15392.246.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 09:58:40AM +0800, Shaohua Li wrote:
[..]
> > > [global]
> > > runtime=30
> > > direct=1
> > > 
> > > [test1]
> > > cgroup=test1
> > > cgroup_weight=1000
> > > rw=randread
> > > ioengine=libaio
> > > size=500m
> > > runtime=30
> > > directory=/mnt
> > > filename=file1
> > > thinktime=9000
> > > 
> > > [test2]
> > > cgroup=test2
> > > cgroup_weight=1000
> > > rw=randread
> > > ioengine=libaio
> > > size=500m
> > > runtime=30
> > > directory=/mnt
> > > filename=file2
> > > 
> > > 	patched		base
> > > test1	64k		39k
> > > test2	540k		540k
> > > total	604k		578k
> > > 
> > > group1 gets much better throughput because it waits less time.

I don't understand it. Thinktime of group test1 is more than 8ms. So now
we should not be idling on test1. Hence test1 should lose some share and
test2 should gain disk share and overall throughput should go up.

I am wondering why throughput of test2 did not go up?

Also can you run some tests to make sure that disk shares of regular
workloads (thinktime less than 8ms) are not impacted.

Thanks
Vivek
