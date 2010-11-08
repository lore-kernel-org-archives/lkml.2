Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab0KHXxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:53:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44952 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab0KHXxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:53:48 -0500
Date: Mon, 8 Nov 2010 18:53:46 -0500
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for October 2010
Message-ID: <20101108235346.GA8498@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Near the end of the month we finally saw the release of Linux 2.6.36.
Just a single fix made it into mainline in this month, showing that the
stabilization period before has worked very well.

Linux 2.6.36 has been another impressive release for XFS, seeing
various performance improvements in the new delayed logging code,
for direct I/O and the sync system call, a few bug fixes, and lots
of cleanups, resulting in a net removal of over 2000 lines of code:

	89 files changed, 1998 insertions(+), 4279 deletions(-)

The merge window for Linux 2.6.37 opened just a few days after the
release of Linux 2.6.36 and already contains another large XFS update
at the end of October.  Highlights of the XFS tree merged into 2.6.37-rc1
are another large set of metadata scalability patches, support for 32-bit
wide project IDs, and support for the new XFS_IOC_ZERO_RANGE ioctl,
which allows to punch a whole and convert it to an unwritten extent
in a single atomic operation.  

The metadata scalability changes improve 8-way fs_mark of 50 million files
by over 15% and removal of those files by over 100%, with further
improvements expected by the next round of XFS metadata scalability
and VFS scalability improvements targeted at Linux 2.6.38.

On the user space side October was a rather quit month for xfsprogs, which
only saw the addition of 32-bit project ID handling, and a fix for
parsing the mount table in fsr when used together with disk encryption
tools.  A few patches for xfsdump were posted on the list, but none
was applied, leaving the majority of the user space activity to
xfstests, which saw very active development.  Various patches went
into xfstests to improve portability to filesystems with a limited
feature set, and to move more filters to generic code.  In addition
various cleanups to test cases in test programs were applied.
