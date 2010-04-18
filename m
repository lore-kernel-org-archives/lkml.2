Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab0DRSBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 14:01:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0DRSBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 14:01:18 -0400
Date: Sun, 18 Apr 2010 14:01:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for March 2010
Message-ID: <20100418180118.GA20394@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The merge window for Linux 2.6.34 closed in the first week of March,
with the important XFS features already landing in February.  Not
surprisingly the XFS merge activity in March has been rather slow,
with only about a dozen bug fixes patches making it towards Linus'
tree in that time.

On the other hand active development for the 2.6.35 merge window has
been very active.  Most importantly there was a lot of work on the
transaction and log subsystems.  Starting with a large patchset to
clean up and refactor the transaction subsystem and introducing more
flexible I/O containers in the low-level logging code work is
progressing to a new, more efficient logging implementation.  While
this preparatory work has already been merged in the development tree,
the actual delayed logging implementation still needs more work after
the initial public posting.  The delayed logging implementation which
is very briefly modeled after the journaling mode in the ext3/4
and reiserfs filesystems allows to accumulated multiple asynchronous
transactions in memory instead of possibly writing them out
many times.  Using the new delayed logging mechanism I/O bandwidth
used for the log decreases by orders of magnitude and performance
on metadata intensive workloads increases massively. 

In addition to that a new version of the discard (aka TRIM) support
has been posted, this time entirely contained in kernel space
and without the need of a userspace utility to drive it.  Last but
not least the usual steady stream of cleanups and bug fixes has not
ceased this month either.

Besides the usual flow of fixes and new test cases in the xfstests
test suite development on the userspace side has been rather slow.
Xfsprogs has only seen a single fix for SMP locking in xfs_repair
and support for building on Debian GNU/kFreeBSD, and xfsdump
has seen no commit at all.
