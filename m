Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab2A0OEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:04:55 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35266
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984Ab2A0OEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:04:54 -0500
Date: Fri, 27 Jan 2012 09:04:53 -0500
From: Christoph Hellwig <hch@infradead.org>
To: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>,
        Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] xfs: change available ranges in quota check
Message-ID: <20120127140453.GA14566@infradead.org>
References: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
 <20120124174612.GC9853@infradead.org>
 <4F22424E.8070407@hitachi.com>
 <20120127110238.GB31093@infradead.org>
 <4F22AE63.2020809@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F22AE63.2020809@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 11:02:11PM +0900, HAYASAKA Mitsuo wrote:
> Hi Christoph,
> 
> I'd like to explain the reason why I sent the patch series.
> 
> Here is an example where I activated user quota and set each softlimit and
> hardlimit as follows.
> 
>        | softlimit | hardlimit 
> -------------------------------
>  block |    1M     |    2M
> -------------------------------
>  inode |     3     |     5
> 
> I succeeded to create files up to the inode hardlimit using touch command.
> The quota information is shown as follows.
> 
> # xfs_quota -x -c 'report -u -b -i -h' /mnt/xfs2
> User quota on /mnt/xfs2 (/dev/vdb)
>                         Blocks                            Inodes              
> User ID      Used   Soft   Hard Warn/Grace     Used   Soft   Hard Warn/Grace  
> ---------- --------------------------------- --------------------------------- 
> root            0      0      0  00 [------]      3      0      0  00 [------]
> xfstest01       0     1M     2M  00 [------]      5      3      5  00 [6 days]
> 						 ~~~~	        ~~
> 
> However, I failed to create and add another file due to the quota limitation.
> 
> $ touch /mnt/xfs2/dir00/file05
> touch: cannot touch `/mnt/xfs2/dir00/file05': Disk quota exceeded
> 
> It seems the inode quota works well.
> 
> Regarding the block quota, I got the quota limitation message even if I
> created a 2MB file which is equal to the hardlimit of disk quota.
> 
> $ dd if=/dev/zero of=/mnt/xfs2/dir00/file01 bs=2M count=1
> dd: writing `/mnt/xfs2/dir00/file01': Disk quota exceeded
> 1+0 records in			     ~~~~~~~~~~~~~~~~~~~~~
> 0+0 records out
> 2093056 bytes (2.1 MB) copied, 0.00561516 s, 373 MB/s
> 
> I'd like to change the available range of the block quota, and
> also change the inode quota check to the same way as the block check
> introduced in PATCH 2/3 to make it more general.

Makes sense.  Can you create an xfstests testcase containing the above
test case?

