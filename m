Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab2GJLcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:32:53 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58155 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2GJLcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:32:52 -0400
Date: Tue, 10 Jul 2012 07:32:37 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lizefan@huawei.com, tj@kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v2] net: cgroup: fix access the unallocated memory in
 netprio cgroup
Message-ID: <20120710113237.GB5215@hmsreliant.think-freely.org>
References: <1341917043-13264-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1341918350.3265.4830.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341918350.3265.4830.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 01:05:50PM +0200, Eric Dumazet wrote:
> On Tue, 2012-07-10 at 18:44 +0800, Gao feng wrote:
> > there are some out of bound accesses in netprio cgroup.
> 
> > -	update_netdev_tables();
> > +	ret = extend_netdev_table(dev, max_len);
> > +	if (ret < 0)
> > +		goto out_free_devname;
> > +
> >  	ret = 0;
> >  	rcu_read_lock();
> >  	map = rcu_dereference(dev->priomap);
> 
> Its unfortunately adding a bug.
> 
> extend_netdev_table() is protected by RTNL.
> 
More specifically it needs to be protected by rtnl, and the call above isn't.
Other than that it looks pretty good to me.
Neil

