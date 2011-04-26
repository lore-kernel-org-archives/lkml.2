Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704Ab1DZVNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:13:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:30103 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647Ab1DZVNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:13:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483457"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: Artem.Bityutskiy@nokia.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [17/106] UBIFS: do not read flash unnecessarily
Message-Id: <20110426211255.A021B3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:12:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit 8b229c76765816796eec7ccd428f03bd8de8b525 upstream.

This fix makes the 'dbg_check_old_index()' function return
immediately if debugging is disabled, instead of executing
incorrect 'goto out' which causes UBIFS to:

1. Allocate memory
2. Read the flash

On every commit. OK, we do not commit that often, but it is
still silly to do unneeded I/O anyway.

Credits to coverity for spotting this silly issue.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ubifs/commit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/fs/ubifs/commit.c
===================================================================
--- linux-2.6.35.y.orig/fs/ubifs/commit.c
+++ linux-2.6.35.y/fs/ubifs/commit.c
@@ -519,7 +519,7 @@ int dbg_check_old_index(struct ubifs_inf
 	size_t sz;
 
 	if (!(ubifs_chk_flags & UBIFS_CHK_OLD_IDX))
-		goto out;
+		return 0;
 
 	INIT_LIST_HEAD(&list);
 
