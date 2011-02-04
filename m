Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1BDAXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 19:23:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46393 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab1BDAXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 19:23:14 -0500
Date: Thu, 3 Feb 2011 19:23:13 -0500
From: Christoph Hellwig <hch@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] hfsplus regression fixes
Message-ID: <20110204002312.GA7354@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the tree with hfsplus regression fixes.  It's mostly fixing
up the mount error path, as changes in this cycle have made the card
house of the old cleanup code collapse, and multiple people have
reported crashes when trying to mount random MAC-looking images or
media.

Also a trivial revert of a hunk from a cleanup patch that incorrectly
changed the comparism operands.

The following changes since commit ebf53826e105f488f4f628703a108e98940d1dc5:

  Linux 2.6.38-rc3 (2011-02-01 13:05:49 +1000)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/hch/hfsplus.git for-linus

Christoph Hellwig (2):
      hfsplus: fix failed mount handling
      hfsplus: fix up a comparism in hfsplus_file_extend

Chuck Ebbert (2):
      hfsplus: do not leak buffer on error
      hfsplus: fix two memory leaks in wrapper.c

 fs/hfsplus/extents.c  |    4 +-
 fs/hfsplus/part_tbl.c |    4 +-
 fs/hfsplus/super.c    |  106 ++++++++++++++++++++++++++++---------------------
 fs/hfsplus/wrapper.c  |    4 +-
 4 files changed, 67 insertions(+), 51 deletions(-)
