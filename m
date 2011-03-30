Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664Ab1C3VUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:20:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:12060 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965182Ab1C3VJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903736605"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mijinlong@cn.fujitsu.com, ak@linux.intel.com, bfields@redhat.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [232/275] nfsd: wrong index used in inner loop
Message-Id: <20110330210757.F3D223E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mi Jinlong <mijinlong@cn.fujitsu.com>

commit 5a02ab7c3c4580f94d13c683721039855b67cda6 upstream.

We must not use dummy for index.
After the first index, READ32(dummy) will change dummy!!!!

Signed-off-by: Mi Jinlong <mijinlong@cn.fujitsu.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[bfields@redhat.com: Trond points out READ_BUF alone is sufficient.]
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4xdr.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6.35.y/fs/nfsd/nfs4xdr.c
===================================================================
--- linux-2.6.35.y.orig/fs/nfsd/nfs4xdr.c	2011-03-29 23:03:01.975249629 -0700
+++ linux-2.6.35.y/fs/nfsd/nfs4xdr.c	2011-03-29 23:03:03.054222021 -0700
@@ -1107,7 +1107,7 @@
 
 	u32 dummy;
 	char *machine_name;
-	int i, j;
+	int i;
 	int nr_secflavs;
 
 	READ_BUF(16);
@@ -1180,8 +1180,6 @@
 			READ_BUF(4);
 			READ32(dummy);
 			READ_BUF(dummy * 4);
-			for (j = 0; j < dummy; ++j)
-				READ32(dummy);
 			break;
 		case RPC_AUTH_GSS:
 			dprintk("RPC_AUTH_GSS callback secflavor "
@@ -1197,7 +1195,6 @@
 			READ_BUF(4);
 			READ32(dummy);
 			READ_BUF(dummy);
-			p += XDR_QUADLEN(dummy);
 			break;
 		default:
 			dprintk("Illegal callback secflavor\n");
