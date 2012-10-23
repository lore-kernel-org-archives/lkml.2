Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab2JWBdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 21:33:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:57649 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320Ab2JWBdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 21:33:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,632,1344236400"; 
   d="scan'208";a="207739832"
Date: Tue, 23 Oct 2012 09:32:57 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] kbuild: fix xargs error on make distclean
Message-ID: <20121023013257.GA21775@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/usr/bin/xargs: unmatched single quote; by default quotes are special to xargs unless you use the -0 option

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index bb9fff2..e5a64cc 100644
--- a/Makefile
+++ b/Makefile
@@ -1033,7 +1033,7 @@ distclean: mrproper
 		-o -name '*.bak' -o -name '#*#' -o -name '.*.orig' \
 		-o -name '.*.rej' \
 		-o -name '*%' -o -name '.*.cmd' -o -name 'core' \) \
-		-type f -print | xargs rm -f
+		-type f -print0 | xargs -0 rm -f
 
 
 # Packaging of the kernel to various formats
-- 
1.7.10

