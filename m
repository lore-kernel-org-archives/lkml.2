Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1EUAOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:14:43 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:21841 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331Ab1EUAOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:14:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj8EAHAD1015LCoegWdsb2JhbACmHxUBARYmJsMsDoYLBJ8Y
Date: Sat, 21 May 2011 10:14:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrey Rahmatullin <wrar@altlinux.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110521001431.GS32466@dastard>
References: <20110423224403.5fd1136a@neptune.home>
 <20110427050850.GG12436@dastard>
 <20110427182622.05a068a2@neptune.home>
 <20110428194528.GA1627@x4.trippels.de>
 <20110429011929.GA13542@dastard>
 <20110520112018.GB3867@belkar.wrar.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520112018.GB3867@belkar.wrar.name>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 05:20:18PM +0600, Andrey Rahmatullin wrote:
> On Fri, Apr 29, 2011 at 11:19:29AM +1000, Dave Chinner wrote:
> > > x4 ~ # xfs_info /
> > > meta-data=/dev/root              isize=256    agcount=4, agsize=1949824 blks
> > >          =                       sectsz=512   attr=2
> > > data     =                       bsize=4096   blocks=7799296, imaxpct=25
> > >          =                       sunit=128    swidth=128 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0
> > > log      =internal               bsize=4096   blocks=3808, version=2
> > >          =                       sectsz=512   sunit=8 blks, lazy-count=1
> > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > OK, so the common elements here appears to be root filesystems
> > with small log sizes, which means they are tail pushing all the
> > time metadata operations are in progress. 
> Does that mean that such filesystems are not optimal in terms of
> performance and/or reliability and should have larger log sizes?

Performance. Larger logs generally result in faster metadata
performance, but it's really dependent on your workload and storage
as to whether it makes any difference.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
