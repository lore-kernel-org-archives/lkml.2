Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164Ab1HNXMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 19:12:19 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45222
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab1HNXMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 19:12:18 -0400
Date: Sun, 14 Aug 2011 19:12:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: XFS status update for July 2011
Message-ID: <20110814231217.GA30171@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

July finally saw the release of Linux 3.0, including a relatively small XFS
update:

  37 files changed, 1168 insertions(+), 847 deletions(-)

The primary news in this release is a complete rework of the busy extent
tracking, which speeds up allocation heavy multithreaded workloads.  This
feature also allowed adding support for discard support at transaction
commit time using the discard mount option.  While the implementation of
discards in XFS is state of the art it should be considered mostly a
technology preview until various efficiency issue in the block layer
discard support are sorted out.  Another important feature visible to
users is that XFS now supports using external logs even when using volatile
write caches, although the implementation is not fully optimized yet,
the rest of the changes consists of the usual pile of bug fixes and a
relatively small set of cleanups.  After the release of Linux 3.0 the
merge window for Linux 3.1 also fell mostly into July.   The XFS merge
for 3.1 included further speedups for the AIL code, and a huge amount
of cleanups.

On the userspace side the biggest item was the merge of the libxfs resync
with the Linux 2.6.39 kernel code.  In addition to that xfsprogs saw small
xfs_repair updates, xfstests saw various fixes to fsx, and various build
system fixes were commit to all userspace repositories.
