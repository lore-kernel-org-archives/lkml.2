Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab2FRMI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:08:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34930
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab2FRMIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:08:54 -0400
Date: Mon, 18 Jun 2012 08:08:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: XFS status update for May 2012
Message-ID: <20120618120853.GA15480@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

May saw the release of Linux 3.4, including a decent sized XFS update.
Remarkable XFS features in Linux 3.4 include moving over all metadata
updates to use transactions, the addition of a work queue for the
low-level allocator code to avoid stack overflows due to extreme stack
use in the Linux VM/VFS call chain, better xattr operation tracing,
fixes for a long-standing but hard to hit deadlock when using the XFS
real time subvolume, and big improvements in disk quota scalability.

The final diffstat for XFS in Linux 3.4 is:

 61 files changed, 1692 insertions(+), 2356 deletions(-)

In the meantime the merge window for Linux 3.5 opened, and another large
update has been merged into Linus' tree.  Interesting changes in Linux
3.5-rc1 include improved error handling on buffer write failures,
a drastic reduction of locking overhead when doing high-IOPS direct I/O,
removal of the old xfsbufd daemon in favor of writing most run-time
metadata from the xfsaild daemon, deferral of CIL pushes to decouple
user space metadata I/O from log writeback, and last but not least the
addition of the SEEK_DATA/SEEK_HOLE lseek arguments that allow user space
programs to deal with sparse files efficiently. Traffic on the mailing list
has been a bit quiet in May, mostly focusing on a wide range of bug fixes,
but little new features.

On the user space side xfs_repair saw a few bug fixes posted to the list
that didn't make it to the repository yet, while xfstests saw it's usual
amount of minor bug fixes.
