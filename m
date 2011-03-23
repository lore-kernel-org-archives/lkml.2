Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab1CWOyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:54:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932337Ab1CWOyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:54:20 -0400
Date: Wed, 23 Mar 2011 10:54:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Juerg Haefliger <juergh@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Support for global block IO throttling?
Message-ID: <20110323145418.GE13315@redhat.com>
References: <AANLkTikEYDdL08=DdJ7fLR08r6sWDCHbNoOuGhxGhm7G@mail.gmail.com>
 <20110323142505.GD13315@redhat.com>
 <AANLkTi=EoPKcBE1miW_-RHgHTBCSDKJ1My=Z40rrhm1x@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=EoPKcBE1miW_-RHgHTBCSDKJ1My=Z40rrhm1x@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 03:39:28PM +0100, Juerg Haefliger wrote:
> Hi Vivek,
> 
> >> Are there any plans to support global (per cgroup) IO throttling in
> >> the near future? I'm in need of this and would gladly work on it if
> >> nobody else is and if people think this is a useful feature. What I
> >> envision is that one can specify the limits of individual devices in a
> >> group but also specify the overall aggregate limit of the whole group.
> >> I just started looking at the throttling code and haven't quite
> >> figured it out yet so it might take me a bit to get up to speed.
> >
> > Hi Juerg,
> >
> > What's the use case? Why do you need global block IO throttling?
> 
> Resource management for guest VMs. I want to make sure a VM cannot
> exceed a certain IO limit. If the VM does IOs to only one device, it
> gets the full specified bandwidth to that single device but if the VM
> talks to multiple devices, it only gets a fraction of the global
> bandwidth per device, not exceeded the global limit.

Can't we specify per device limit for VM if VM is doing IO to multiple
devices?

I know it is not exact replacement of global limits as one has to know
the topology and figure out to what all devices IO is happening. This
might get even more difficult if VM's disk is a file on filesystem on
host and not a device directly eported to guest.

Somebody also had mentioned that if we have mutiple layers of qemu
snapshots and if snapshots are sitting on different logical devices
then it becomes hard to figure out where all VM traffic is going
and how to even divide global limits in per device limits 

Also current IO controller does not work for NFS. So if a global limit
is imposed in higher layers it will solve that issue too.

Also if you implement it above page cache then it should automatically
handle the case of async writes too. The downside is that if limits
are low, buffered writers will be throttled very frequently.

So in general, I think global limits is a useful concept. Do you have
a implementation ready?

Thanks
Vivek
