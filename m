Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0G1BRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 21:17:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab0G1BRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 21:17:33 -0400
Date: Wed, 28 Jul 2010 04:12:04 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sridhar Samudrala <sri@us.ibm.com>
Cc: netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Make vhost multi-threaded and associate each thread to its
 guest's cgroup
Message-ID: <20100728011203.GA22999@redhat.com>
References: <20100727204254.GA17947@redhat.com>
 <1280277701.27059.11.camel@w-sridhar.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280277701.27059.11.camel@w-sridhar.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 05:41:41PM -0700, Sridhar Samudrala wrote:
> On Tue, 2010-07-27 at 23:42 +0300, Michael S. Tsirkin wrote:
> > Sridhar,
> > I pushed a patchset with all known issues fixed,
> > on my vhost-net-next branch.
> > 
> > For now this ignores the cpu mask issue, addressing
> > only the cgroups issue.
> > 
> > Would appreciate testing and reports.
> 
> I had to apply the following patch to get it build.
> With this patch, i am seeing similar results as i saw earlier.
> 
> Thanks
> Sridhar


Excellent, thanks for the testing.


> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 996e751..8543898 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -23,6 +23,7 @@
>  #include <linux/highmem.h>
>  #include <linux/slab.h>
>  #include <linux/kthread.h>
> +#include <linux/cgroup.h>
>  
>  #include <linux/net.h>
>  #include <linux/if_packet.h>
> @@ -252,7 +253,7 @@ static long vhost_dev_set_owner(struct vhost_dev *dev)
>  	}
>  
>  	dev->worker = worker;
> -	err = cgroup_attach_task_current_cg(poller);
> +	err = cgroup_attach_task_current_cg(worker);
>  	if (err)
>  		goto err_cgroup;
>  	wake_up_process(worker);	/* avoid contributing to loadavg */
> 
