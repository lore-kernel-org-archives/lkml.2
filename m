Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab2EOIMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:12:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:58715 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757658Ab2EOIMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:12:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="143270326"
Date: Tue, 15 May 2012 16:12:49 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: remove redudent code
Message-ID: <20120515081249.GG10252@yliu-dev.sh.intel.com>
References: <1337068825-11995-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20120515180349.0f0d275e@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515180349.0f0d275e@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 06:03:49PM +1000, NeilBrown wrote:
> On Tue, 15 May 2012 16:00:25 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
> wrote:
> 
> > The code does nothing but repating assigning sb->sb_csum with original
> > value.
> 
> This code sets the sb_csum to 0 while the csum is calculated.
> 
> Without this, calculating the csum, setting it, then calculating again would
> produce a different result.
> 
> So the code is correct as is.

Aha, got it. And sorry for the wrong patch.

Thanks,
Yuanhan Liu

> 
> Thanks,
> NeilBrown
> 
> 
> > 
> > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > ---
> >  drivers/md/md.c |    4 ----
> >  1 files changed, 0 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 0bd44e3..f2d799a 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -1439,15 +1439,12 @@ super_90_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
> >  
> >  static __le32 calc_sb_1_csum(struct mdp_superblock_1 * sb)
> >  {
> > -	__le32 disk_csum;
> >  	u32 csum;
> >  	unsigned long long newcsum;
> >  	int size = 256 + le32_to_cpu(sb->max_dev)*2;
> >  	__le32 *isuper = (__le32*)sb;
> >  	int i;
> >  
> > -	disk_csum = sb->sb_csum;
> > -	sb->sb_csum = 0;
> >  	newcsum = 0;
> >  	for (i=0; size>=4; size -= 4 )
> >  		newcsum += le32_to_cpu(*isuper++);
> > @@ -1456,7 +1453,6 @@ static __le32 calc_sb_1_csum(struct mdp_superblock_1 * sb)
> >  		newcsum += le16_to_cpu(*(__le16*) isuper);
> >  
> >  	csum = (newcsum & 0xffffffff) + (newcsum >> 32);
> > -	sb->sb_csum = disk_csum;
> >  	return cpu_to_le32(csum);
> >  }
> >  
> 


