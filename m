Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1A0XkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 18:40:06 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:38357 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965Ab1A0XkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 18:40:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtAEAAOPQU15LN5mgWdsb2JhbACkfBYBARYiJLxmDYVCBA
Date: Fri, 28 Jan 2011 10:39:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
Message-ID: <20110127233929.GM21311@dastard>
References: <4D40C8D1.8090202@teksavvy.com>
 <20110127033011.GH21311@dastard>
 <4D40EB2F.2050809@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D40EB2F.2050809@teksavvy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 10:49:03PM -0500, Mark Lord wrote:
> On 11-01-26 10:30 PM, Dave Chinner wrote:
> > [Please cc xfs@oss.sgi.com on XFS bug reports. Added.]
> >
> > On Wed, Jan 26, 2011 at 08:22:25PM -0500, Mark Lord wrote:
> >> Alex / Christoph,
> >>
> >> My mythtv box here uses XFS on a 2TB drive for storing recordings and videos.
> >> It is behaving rather strangely though, and has gotten worse recently.
> >> Here is what I see happening:
> >>
> >> The drive mounts fine at boot, but the very first attempt to write a new file
> >> to the filesystem suffers from a very very long pause, 30-60 seconds, during which
> >> time the disk activity light is fully "on".
> >
> > Please post the output of xfs_info <mtpt> so we can see what you
> > filesystem configuration is.
> 
>    /dev/sdb1 on /var/lib/mythtv type xfs
> (rw,noatime,allocsize=64M,logbufs=8,largeio)
> 
>    [~] xfs_info /var/lib/mythtv
>    meta-data=/dev/sdb1              isize=256    agcount=7453, agsize=65536 blks
>             =                       sectsz=512   attr=2
>    data     =                       bsize=4096   blocks=488378638, imaxpct=5
>             =                       sunit=0      swidth=0 blks
>    naming   =version 2              bsize=4096   ascii-ci=0
>    log      =internal               bsize=4096   blocks=32768, version=2
>             =                       sectsz=512   sunit=0 blks, lazy-count=0
>    realtime =none                   extsz=4096   blocks=0, rtextents=0

7453 AGs means that the first write coud cause up to ~7500 disk
reads to occur as the AGF headers are read in to find where the
best free space extent for allocation lies.

That'll be your problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
