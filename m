Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab0FONWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:22:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0FONWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:22:22 -0400
Date: Tue, 15 Jun 2010 09:22:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: XFS status update for May 2010
Message-ID: <20100615132221.GA17385@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In May 2010 we saw the long awaited release of Linux 2.6.34, which includes
a large XFS update.  The most important features appearing in 2.6.34 was the
new inode and quota flushing code, which leads to much better I/O patterns
for metadata-intensive workloads.  Additionally support for synchronous NFS
exports has been improved to give much better performance, and performance
for the fsync, fdatasync and sync system calls has been improved slightly.
A bug when resizing extremely busy filesystems has been fixed, which required
extensive modification to the data structure used for looking up the
per-allocation group data.  Last but not least there was a steady flow of
minor bug fixes and cleanups, leading to the following diffstat from
2.6.33 to 2.6.34:

  86 files changed, 3209 insertions(+), 3178 deletions(-)

Meanwhile active development aimed at 2.6.35 merge progressed.  The
major feature for this window is the merge of the delayed logging code,
which adds a new logging mode that dramatically reduces the bandwidth
required for log I/O.  See the documentation [1] for details.  Testers
for this new code are welcome.

In userland xfsprogs saw the long awaited 3.1.2 release, which can be
considered a bug fix release for xfs_repair, xfs_fsr and mkfs.xfs.  After
the release a few more fixes were merged into the development tree.
The xfstests package saw various new tests, including many tests to
exercise the quota code, and a few fixes to existing tests.

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/filesystems/xfs-delayed-logging-design.txt;h=96d0df28bed323d5596fc051b0ffb96ed8e3c8df;hb=HEAD

