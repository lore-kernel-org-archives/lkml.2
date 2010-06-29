Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0F2BER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 21:04:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42961 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0F2BEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 21:04:15 -0400
Date: Mon, 28 Jun 2010 21:04:05 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Dan Carpenter <error27@gmail.com>, Yan Zheng <zheng.yan@oracle.com>,
       Diego Calleja <diegocg@gmail.com>, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] btrfs: make code reachable in btrfs_insert_some_items()
Message-ID: <20100629010405.GU1993@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Miao Xie <miaox@cn.fujitsu.com>, Dan Carpenter <error27@gmail.com>,
	Yan Zheng <zheng.yan@oracle.com>, Diego Calleja <diegocg@gmail.com>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100628111726.GI19184@bicker>
 <4C294512.8070302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C294512.8070302@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0209.4C294689.0066:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 08:57:54AM +0800, Miao Xie wrote:
> Hi,
> 
> on 2010-6-28 19:17, Dan Carpenter wrote:
> > The break was in front of the "nr = i" assignment so that was never hit.
> 
> This bug has been fixed a month ago, and the patch has been merged into the
> btrfs-unstable tree.

This was one that we took out to keep the pull request down to the
critical fixes.  That function actually isn't called, I'll just remove
it.

-chris

> 
>   http://marc.info/?l=linux-btrfs&m=127434036913484&w=2
> 
> Thanks
> Miao
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > 
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > index 0d1d966..ceb8ad2 100644
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -3453,8 +3453,8 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
> >  	for (i = 0; i < nr; i++) {
> >  		if (total_size + data_size[i] + sizeof(struct btrfs_item) >
> >  		    BTRFS_LEAF_DATA_SIZE(root)) {
> > -			break;
> >  			nr = i;
> > +			break;
> >  		}
> >  		total_data += data_size[i];
> >  		total_size += data_size[i] + sizeof(struct btrfs_item);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
