Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1G0Ag1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:36:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:48912 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab1G0Afa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="34855933"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: bookjovi@gmail.com, Trond.Myklebust@netapp.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] [37/98] nfs: fix compilation warning
Message-Id: <20110727003529.9C4F02403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jovi Zhang <bookjovi@gmail.com>

commit 43b7c3f051dea504afccc39bcb56d8e26c2e0b77 upstream.

this commit fix compilation warning as following:
linux-2.6/fs/nfs/nfs4proc.c:3265: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfs/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/fs/nfs/nfs4proc.c
===================================================================
--- linux-2.6.35.y.orig/fs/nfs/nfs4proc.c
+++ linux-2.6.35.y/fs/nfs/nfs4proc.c
@@ -3284,7 +3284,7 @@ static int buf_to_pages_noslab(const voi
 	spages = pages;
 
 	do {
-		len = min(PAGE_CACHE_SIZE, buflen);
+		len = min_t(size_t, PAGE_CACHE_SIZE, buflen);
 		newpage = alloc_page(GFP_KERNEL);
 
 		if (newpage == NULL)
