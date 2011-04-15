Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab1DOVgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:36:17 -0400
Received: from kroah.org ([198.145.64.141]:52274 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab1DOVgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:36:15 -0400
Date: Fri, 15 Apr 2011 14:35:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.32.38
Message-ID: <20110415213517.GD30847@kroah.com>
References: <20110415213458.GC30847@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415213458.GC30847@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index f5fac8b..7bdf889 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 32
-EXTRAVERSION = .37
+EXTRAVERSION = .38
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index f7d8c08..6b09b94 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -473,14 +473,6 @@ static struct rds_rdma_op *rds_rdma_prepare(struct rds_sock *rs,
 
 		max_pages = max(nr, max_pages);
 		nr_pages += nr;
-
-		/*
-		 * nr_pages for one entry is limited to (UINT_MAX>>PAGE_SHIFT)+1,
-		 * so tot_pages cannot overflow without first going negative.
-		 */
-		if ((int)nr_pages < 0)
-			ret = -EINVAL;
-			goto out;
 	}
 
 	pages = kcalloc(max_pages, sizeof(struct page *), GFP_KERNEL);
