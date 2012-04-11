Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab2DKTkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:40:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:24742 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756993Ab2DKTkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:40:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="131319268"
From: Jim Kukunas <james.t.kukunas@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, hpa@zytor.com
Subject: [PATCH 1/4] lib/raid6: fix test program build
Date: Wed, 11 Apr 2012 12:40:28 -0700
Message-Id: <1334173231-28595-2-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1334173231-28595-1-git-send-email-james.t.kukunas@linux.intel.com>
References: <1334173231-28595-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/module.h> drags in headers which are not visible to userspace,
thus breaking the build for the test program.

Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
---
 lib/raid6/algos.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 8b02f60..f6a0f78 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -17,11 +17,11 @@
  */
 
 #include <linux/raid/pq.h>
-#include <linux/module.h>
 #ifndef __KERNEL__
 #include <sys/mman.h>
 #include <stdio.h>
 #else
+#include <linux/module.h>
 #include <linux/gfp.h>
 #if !RAID6_USE_EMPTY_ZERO_PAGE
 /* In .bss so it's zeroed */
-- 
1.7.8.5

