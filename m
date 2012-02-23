Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab2BWUc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:32:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab2BWUc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:32:58 -0500
Date: Thu, 23 Feb 2012 15:32:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120223203241.GJ19691@redhat.com>
References: <20120221211938.GE12236@google.com>
 <20120222163858.GB4128@redhat.com>
 <4F45F1F0.2010102@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F45F1F0.2010102@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 03:59:44PM +0800, Li Zefan wrote:
> > Trying to make all the controllers uniform in terms of their treatment
> > of cgroup hiearchy sounds like a good thing to do.
> 
> Agreed.
> 
> Apart from nesting cgroups, there're other inconsistencies.
> 
> - Some controllers disallow more than one cgroup layer. That's the new
> net_prio controller, and I don't know why it's made so, but I guess
> it's fine to eliminate this restriction.

You mean don't allow creating deeper levels in cgroup hierarcy? That will
fail with libvirt + systemd as they create much deeper levels. I had to
change that for blkio.

> 
> - Some controllers move resource charges when a task is moved to
> a different cgroup, but some don't?

I think in case of some controllers it does not even apply. For cpu, blkio
resources are renewable, so there is no moving around of charges.

Thanks
Vivek
