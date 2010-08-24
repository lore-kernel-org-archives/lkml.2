Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0HXCq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 22:46:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab0HXCqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 22:46:54 -0400
Date: Mon, 23 Aug 2010 22:50:24 -0400
From: Josef Bacik <josef@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] btrfs: update stats when allocating from a cluster
Message-ID: <20100824025023.GA2638@dhcp231-156.rdu.redhat.com>
References: <4C71CD4B.10606@cn.fujitsu.com> <4C71CD91.4050703@cn.fujitsu.com> <20100823130932.GD2404@localhost.localdomain> <4C731771.1060904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C731771.1060904@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 08:50:57AM +0800, Li Zefan wrote:
> >>  	spin_unlock(&cluster->lock);
> >>  
> >> +	if (!ret)
> >> +		return 0;
> >> +
> >> +	spin_lock(&block_group->tree_lock);
> >> +
> >> +	block_group->free_space -= bytes;
> >> +	if (entry->bytes == 0) {
> >> +		block_group->free_extents--;
> >> +		kfree(entry);
> >> +	}
> >> +
> >> +	spin_unlock(&block_group->tree_lock);
> >> +
> > 
> > Move this part up so we don't drop the spinlock and then re-grab it.  Thanks,
> > 
> 
> But they are 2 different locks. ;)
> 
> And we can't grab block_group->tree_lock when holding cluster->lock.

Ugh Jesus sorry, ignore me.

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
