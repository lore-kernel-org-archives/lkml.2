Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab2IKPdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 11:33:43 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59326 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2IKPdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 11:33:42 -0400
Date: Tue, 11 Sep 2012 11:33:09 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, davem@davemloft.net,
        john.r.fastabend@intel.com, gaofeng@cn.fujitsu.com,
        eric.dumazet@gmail.com, mark.d.rustad@intel.com, lizefan@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] netprio_cgroup: Optimize the priomap copy loop
 slightly
Message-ID: <20120911153309.GA25666@hmsreliant.think-freely.org>
References: <20120911112231.13852.61794.stgit@srivatsabhat.in.ibm.com>
 <20120911112237.13852.1095.stgit@srivatsabhat.in.ibm.com>
 <AE90C24D6B3A694183C094C60CF0A2F6026B6FE9@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6FE9@saturn3.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 12:42:23PM +0100, David Laight wrote:
> > -	for (i = 0;
> > -	     old_priomap && (i < old_priomap->priomap_len);
> > -	     i++)
> > -		new_priomap->priomap[i] = old_priomap->priomap[i];
> > +	if (old_priomap) {
> > +		old_len = old_priomap->priomap_len;
> > +
> > +		for (i = 0; i < old_len; i++)
> > +			new_priomap->priomap[i] = old_priomap->priomap[i];
> > +	}
> 
> Or:
> 	memcpy(new_priomap->priomap, old_priomap->priomap,
> 		old_priomap->priomap_len * sizeof old_priomap->priomap[0]);
> 
> 	David
> 
Yes, the memcpy would be better here.
Neil

