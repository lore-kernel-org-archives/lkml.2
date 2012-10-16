Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2JPLtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:49:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:42631 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab2JPLsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:48:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="234474126"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv3 0/6] lib/string: introduce kbasename helper
Date: Tue, 16 Oct 2012 14:48:07 +0300
Message-Id: <1350388094-18805-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several places in kernel that duplicate code to get last part of the
pathname. This patchset introduces a helper and few fixes.

Since v2:
- fixed Cc list in the patch 6/6 ("trace: ...")
- update patch 3/6 ("rts_pstor: ...") to not hide const qualifier
- send patch 1/1 to all people involved to the series
- rebase against recent linux-next
Since v1:
- fix changelog of the patch 1 - we are doing basename(3) alike helper
- usb related patch temporary excluded from series (under discussion with Greg)

Andy Shevchenko (6):
  lib/string: introduce helper to get base file name from given path
  lib: dynamic_debug: reuse kbasename()
  staging: rts_pstor: reuse kbasename()
  mm: reuse kbasename() functionality
  procfs: reuse kbasename() functionality
  trace: reuse kbasename() functionality

 drivers/staging/rts_pstor/trace.h |   24 ++++--------------------
 fs/proc/proc_devtree.c            |    7 ++-----
 include/linux/string.h            |   11 +++++++++++
 kernel/trace/trace_uprobe.c       |    8 ++++----
 lib/dynamic_debug.c               |    9 +--------
 mm/memory.c                       |    8 +++-----
 6 files changed, 25 insertions(+), 42 deletions(-)

-- 
1.7.10.4

