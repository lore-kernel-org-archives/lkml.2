Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab1GFHIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 03:08:06 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36526
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990Ab1GFHIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 03:08:04 -0400
Date: Wed, 6 Jul 2011 03:07:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: T?r?k Edwin <edwintorok@gmail.com>, xfs-masters@oss.sgi.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: XFS internal error (memory corruption)
Message-ID: <20110706070756.GA25800@infradead.org>
References: <4E12A927.9020102@gmail.com>
 <20110705130932.GF1026@dastard>
 <4E1313C1.6020309@gmail.com>
 <20110706040403.GW1026@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706040403.GW1026@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 02:04:03PM +1000, Dave Chinner wrote:
> > Although is there supposed to be a performance benefit from having
> > a separate log disk with XFS?
> 
> There used to be. Now everyone just uses delayed logging, which is
> far faster and more scalable that even using an external log.

Even with delayed logging external logs are a huge benefit if you
hit the log hard, e.g. for fsync intensive workloads.  E.g. when
using fs_mark in fsync mode it gives speedups over 100% for the
setups I've tested.  You'll see similar speedups for NFS server
loads that are log force heavy as well.

> 
> > IIRC it has a disadvantage that you can't use barriers properly.
> 
> That mostly works now (recent kernels), but you take a hit in
> journal IO waiting synchronously for the data device caches to be
> flushed before writing to the log device.

For metadata-heavy workloads where an external log benefits you most
you generally just want to disable the volatile write cache anyway.

