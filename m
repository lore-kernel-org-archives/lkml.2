Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab2I1QzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:55:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:43126 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757365Ab2I1QzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:55:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,502,1344236400"; 
   d="scan'208";a="199430315"
Date: Fri, 28 Sep 2012 12:55:11 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: [GIT PULL] Fixes for the NVMe driver
Message-ID: <20120928165511.GB4244@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Now that actual hardware has been released (don't have any yet myself),
people are starting to want some of these fixes merged.  Could I trouble
you to pull?


The following changes since commit df3481399042200792822b6243e36a95a557b57e:

  NVMe: Set number of queues correctly (2012-01-11 09:22:24 -0500)

are available in the git repository at:

  git://git.infradead.org/users/willy/linux-nvme.git master

for you to fetch changes up to a09115b23e2002bb35b7bfd337683f00875671ec:

  NVMe: Cancel outstanding IOs on queue deletion (2012-08-07 15:56:23 -0400)

----------------------------------------------------------------
Dan Carpenter (1):
      NVMe: handle allocation failure in nvme_map_user_pages()

Keith Busch (7):
      NVMe: Set request queue logical block size
      NVMe: Fix nvme module init when nvme_major is set
      NVMe: replace nvme_ns with nvme_dev for user admin
      NVMe: use namespace id for nvme_get_features
      NVMe: Set block queue max sectors
      NVMe: Do not set IO queue depth beyond device max
      NVMe: Fix uninitialized iod compiler warning

Matthew Wilcox (3):
      NVMe: Fix whitespace damage in nvme_init
      NVMe: Free admin queue memory on initialisation failure
      NVMe: Cancel outstanding IOs on queue deletion

Quoc-Son Anh (1):
      NVMe: Use ida for nvme device instance

 drivers/block/nvme.c |  153 +++++++++++++++++++++++++++++++++-----------------
 include/linux/nvme.h |    2 +
 2 files changed, 105 insertions(+), 50 deletions(-)
