Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab0JNUzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 16:55:13 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:43851 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755295Ab0JNUzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 16:55:11 -0400
Date: Fri, 15 Oct 2010 07:55:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs-masters@oss.sgi.com,
        lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [xfs-masters] [PATCH -next] xfs: eliminate kconfig dependency
 warning
Message-ID: <20101014205502.GC4681@dastard>
References: <20101013210142.9d524535.randy.dunlap@oracle.com>
 <20101014092503.GA28446@lst.de>
 <4CB73B5B.30108@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB73B5B.30108@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 10:18:19AM -0700, Randy Dunlap wrote:
> On 10/14/10 02:25, Christoph Hellwig wrote:
> > On Wed, Oct 13, 2010 at 09:01:42PM -0700, Randy Dunlap wrote:
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> Fix kconfig dependency warning to satisfy dependencies:
> >>
> >> warning: (XFS_FS && BLOCK || NFSD && NETWORK_FILESYSTEMS && INET && FILE_LOCKING && BKL) selects EXPORTFS which has unmet direct dependencies (NETWORK_FILESYSTEMS)
> > 
> > I'm not entirely sure what this gibberish means, but I'm pretty sure it
> > does not make sense.
> > 
> > EXPORTFS is a small module that doesn't have any dependencie, and it's
> > needed by XFS for the by-handle operation, and by nfsd for the same
> > thing.  It has absolutely nothing to do with networking or network
> > filesystems (as in network filesystem clients).
> 
> The (kconfig) warning/problem is that exportfs is in the Networking Filesystems menu,
> under the kconfig symbol NETWORK_FILESYSTEMS.

Thanks for the explanation, Randy.

> Dave Chinner wrote:
> | EXPORTFS functionality actually has use for local filesystems - the
> | open-by-handle interfaces in XFS are what uses it, and there are patches
> | about that make this generic for most filesystems. Hence it seems to
> | me that the correct thing to do is separate EXPORTFS from
> | NETWORK_FILESYSTEMS, not make local filesystems depend on a user
> | selecting network filesystem support....
> 
> Agreed.  Is that Kconfig change also part of the "patches about"?

I can't remember exactly what it does with the kconfig symbols.
Information about the patch series (including a link to the git repo
storing the changes) is here:

http://marc.info/?l=linux-fsdevel&m=128627415827161&w=2

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
