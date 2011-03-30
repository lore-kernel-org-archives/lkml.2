Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619Ab1C3VJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:49760 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965014Ab1C3VIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133604"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: roel.kluin@gmail.com, bfields@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [180/275] nfsd: wrong index used in inner loop
Message-Id: <20110330210703.3DEB73E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: roel <roel.kluin@gmail.com>

commit 3ec07aa9522e3d5e9d5ede7bef946756e623a0a0 upstream.


Index i was already used in the outer loop

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfsd/nfs4xdr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/fs/nfsd/nfs4xdr.c
===================================================================
--- linux-2.6.35.y.orig/fs/nfsd/nfs4xdr.c	2011-03-29 23:03:00.858278209 -0700
+++ linux-2.6.35.y/fs/nfsd/nfs4xdr.c	2011-03-29 23:53:57.803058641 -0700
@@ -1107,7 +1107,7 @@
 
 	u32 dummy;
 	char *machine_name;
-	int i;
+	int i, j;
 	int nr_secflavs;
 
 	READ_BUF(16);
@@ -1180,7 +1180,7 @@
 			READ_BUF(4);
 			READ32(dummy);
 			READ_BUF(dummy * 4);
-			for (i = 0; i < dummy; ++i)
+			for (j = 0; j < dummy; ++j)
 				READ32(dummy);
 			break;
 		case RPC_AUTH_GSS:
