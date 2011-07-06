Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1GFHWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 03:22:25 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:24716 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751591Ab1GFHWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 03:22:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsDACUKFE55LCkBgWdsb2JhbABTqAgVAQEWJiXNEQ6GKASjDg
Date: Wed, 6 Jul 2011 17:22:21 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: T?r?k Edwin <edwintorok@gmail.com>, xfs-masters@oss.sgi.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: XFS internal error (memory corruption)
Message-ID: <20110706072221.GZ1026@dastard>
References: <4E12A927.9020102@gmail.com>
 <20110705130932.GF1026@dastard>
 <4E1313C1.6020309@gmail.com>
 <20110706040403.GW1026@dastard>
 <20110706070756.GA25800@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706070756.GA25800@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 03:07:56AM -0400, Christoph Hellwig wrote:
> On Wed, Jul 06, 2011 at 02:04:03PM +1000, Dave Chinner wrote:
> > > Although is there supposed to be a performance benefit from having
> > > a separate log disk with XFS?
> > 
> > There used to be. Now everyone just uses delayed logging, which is
> > far faster and more scalable that even using an external log.
> 
> Even with delayed logging external logs are a huge benefit if you
> hit the log hard, e.g. for fsync intensive workloads.  E.g. when
> using fs_mark in fsync mode it gives speedups over 100% for the
> setups I've tested.  You'll see similar speedups for NFS server
> loads that are log force heavy as well.

Unless you have a good sized chunk of BBWC in front of your disks,
in which case internal logs are just as fast. In fact, internal logs
can are often faster in this case because an internal log on a 12
disk RAID6 array can sink a whole log more bandwidth than an external
log on a 2-disk RAID0 mirror.....

At least, that's what my hardware tells me. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
