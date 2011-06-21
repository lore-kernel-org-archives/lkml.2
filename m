Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1FUBin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 21:38:43 -0400
Received: from mail09.linbit.com ([212.69.161.110]:56135 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab1FUBil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 21:38:41 -0400
Subject: Re: [PATCH] xattr: Fix error results for non-existent / invisible
 attributes
From: Andreas Gruenbacher <agruen@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20110620080921.GA23159@infradead.org>
References: <201105271450.37089.agruen@kernel.org>
	 <20110620080921.GA23159@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 03:34:17 +0200
Message-ID: <1308620057.2983.17.camel@schurl.linbit>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-20 at 04:09 -0400, Christoph Hellwig wrote:
> On Fri, May 27, 2011 at 02:50:36PM +0200, Andreas Gruenbacher wrote:
> > Return -ENODATA when trying to read a user.* attribute which cannot
> > exist: user space otherwise does not have a reasonable way to
> > distinguish between non-existent and inaccessible attributes.
> > 
> > Likewise, return -ENODATA when an unprivileged process tries to read a
> > trusted.* attribute: to unprivileged processes, those attributes are
> > invisible (listxattr() won't include them).
> 
> This breaks xfstests 062.

The test does a "getfattr -n <name> <file>" for an attribute which
cannot exist.  The kernel now returns ENODATA instead of the previous
EPERM.

One way to fix this in xfstests is to use listxattr(2) instead of
getxattr(2), e.g.,

	- getfattr -m $nsp -n $nsp.name2 $SCRATCH_MNT/$inode
	+ getfattr -m $nsp.name2 $SCRATCH_MNT/$inode

Another is to accept ENODATA as well as EPERM.  Not sure which is preferable.

Andreas

