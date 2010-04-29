Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812Ab0D3SFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:05:09 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:43349 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759026Ab0D3SC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:02:28 -0400
Date: Thu, 29 Apr 2010 14:37:32 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] padata: Dont scale the parallel objects with the cpus
Message-ID: <20100429123732.GE5275@secunet.com>
References: <20100429123636.GD5275@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100429123636.GD5275@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Apr 2010 12:32:29.0428 (UTC) FILETIME=[08547B40:01CAE798]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scaling the maximum number of objects in the parallel
codepath can lead to out of memory problems on bigsmp
machines.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 70b5d5e..5b44d0f 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -29,7 +29,7 @@
 #include <linux/rcupdate.h>
 
 #define MAX_SEQ_NR INT_MAX - NR_CPUS
-#define MAX_OBJ_NUM 10000 * NR_CPUS
+#define MAX_OBJ_NUM 1000
 
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 {
-- 
1.5.6.5

