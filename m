Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab1KWNf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 08:35:26 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:50162 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab1KWNfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 08:35:22 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Shaohua Li <shaohua.li@intel.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/5] mm: per-zone dirty limits v3-resend
Date: Wed, 23 Nov 2011 14:34:13 +0100
Message-Id: <1322055258-3254-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of version 3, rebased to v3.2-rc2.  In addition to my
own tests - results in 3/5 - Wu Fengguang also ran tests of his own in
combination with the IO-less dirty throttling series, the results of
which can be found here:

	http://article.gmane.org/gmane.comp.file-systems.ext4/28795
	http://article.gmane.org/gmane.linux.kernel.mm/69648

Per-zone dirty limits try to distribute page cache pages allocated for
writing across zones in proportion to the individual zone sizes, to
reduce the likelihood of reclaim having to write back individual pages
from the LRU lists in order to make progress.

Please consider merging into 3.3.

 fs/btrfs/file.c           |    2 +-
 include/linux/gfp.h       |    4 +-
 include/linux/mmzone.h    |    6 +
 include/linux/swap.h      |    1 +
 include/linux/writeback.h |    1 +
 mm/filemap.c              |    5 +-
 mm/page-writeback.c       |  290 +++++++++++++++++++++++++++++----------------
 mm/page_alloc.c           |   48 ++++++++
 8 files changed, 251 insertions(+), 106 deletions(-)
