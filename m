Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1BMSm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 13:42:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58712 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab1BMSmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 13:42:20 -0500
Date: Sun, 13 Feb 2011 13:42:19 -0500
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: XFS status update for January 2011
Message-ID: <20110213184219.GA22792@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the 4th of January we saw the release of Linux 2.6.37, which contains a
large XFS update:

    67 files changed, 1424 insertions(+), 1524 deletions(-)

User visible changes are the new XFS_IOC_ZERO_RANGE ioctl which allows
to convert already allocated space into unwritten extents that return
zeros on a read, and support for 32-bit wide project IDs.  The other large
item are various changes to improve metadata scalability even further,
by changes to the the buffer cache, inode lookup and other parts of the
filesystem driver.

After that the XFS development tree for 2.6.38 was merged into mainline,
with an even larger set of changes.  Notable items include support for the
FITRIM ioctl to discard unused space on SSDs and thinly provisioned storage
systems, a buffer LRU scheme to improve hit rates for metadata, an
overhaul of the log subsystem locking, dramatically improving scalability
in that area, and much smarter handling of preallocations, especially
for files closed and reopened frequently, e.g. by the NFS server.

User space development has been very quite, with just a few fixes committed
to the xfstests repository, although various additional patches for xfsprogs
and xfstests that haven't been committed yet were discussed on the mailing list.
