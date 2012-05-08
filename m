Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab2EHPf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:35:28 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34253
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756484Ab2EHPf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:35:26 -0400
Date: Tue, 8 May 2012 11:35:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: XFS status update for March 2012
Message-ID: <20120508153526.GA8176@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

March saw the release of Linux 3.3, which saw an XFS update slightly smaller
than usual, and consisting largely of code removal and cleanups, with the
only user visible change being the removal of the old logging code, and thus
the "nodelaylog" mount option.  This is reflected in a diffstat with more
than twice as many deletions as additions:

  45 files changed, 954 insertions(+), 2182 deletions(-)

After that Linux 3.4 merge window opened, and a big XFS updates was merged
into mainline, again removing a lot more code than adding it.  The
highlight are quota changes to make in-memory quota caching a lot faster
and more scalable, as well as changes to log all metadata updates on a
live XFS filesystem, thus finishing the consolidation of all metadata I/O
code pathes to just after many years of hard work.

Development for the Linux 3.5 merge window also were in full steam,
including a series to kill the xfsbufd daemon in favour of on-stack
delayed buffer writeback lists.

On the user space side we finally saw the long awaited xfsprogs 3.1.8 
and xfsdump 3.1.0 releases.  The new xfsprogs release features a larger
number of repair fixes and speedups, as well as smaller updates to the
other tools.  All users are recommended to upgrade to this version.
Major updates in xfsdump 3.1.0 is support for dumping multiple I/O
streams in parallel, a new dump format to support all 32 bits of the
inode generation number, removal of support for the old SGI_XFSDUMP_SKIP_FILE
extended attribute, as well as various smaller fixes.

Development of xfstests included at its normal pace, with a few new
test cases for xfsdump, as well as various fixes for existing test cases
and the addition of a new "dangerous" group to skip tests that potentially
crash the system if an too old kernel is used.
