Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827Ab0D3SGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:06:09 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:43346 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759023Ab0D3SC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:02:27 -0400
Date: Thu, 29 Apr 2010 14:40:53 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] padata: Remove superfluous might_sleep
Message-ID: <20100429124053.GG5275@secunet.com>
References: <20100429123636.GD5275@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100429123636.GD5275@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 Apr 2010 12:35:49.0750 (UTC) FILETIME=[7FBB3160:01CAE798]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

might_sleep() was placed before mutex_lock() in some places.
We remove them because mutex_lock() does might_sleep() too.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 1209a17..5fa6ba6 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -443,8 +443,6 @@ int padata_set_cpumask(struct padata_instance *pinst,
 	struct parallel_data *pd;
 	int err = 0;
 
-	might_sleep();
-
 	mutex_lock(&pinst->lock);
 
 	pd = padata_alloc_pd(pinst, cpumask);
@@ -489,8 +487,6 @@ int padata_add_cpu(struct padata_instance *pinst, int cpu)
 {
 	int err;
 
-	might_sleep();
-
 	mutex_lock(&pinst->lock);
 
 	cpumask_set_cpu(cpu, pinst->cpumask);
@@ -527,8 +523,6 @@ int padata_remove_cpu(struct padata_instance *pinst, int cpu)
 {
 	int err;
 
-	might_sleep();
-
 	mutex_lock(&pinst->lock);
 
 	cpumask_clear_cpu(cpu, pinst->cpumask);
@@ -547,8 +541,6 @@ EXPORT_SYMBOL(padata_remove_cpu);
  */
 void padata_start(struct padata_instance *pinst)
 {
-	might_sleep();
-
 	mutex_lock(&pinst->lock);
 	pinst->flags |= PADATA_INIT;
 	mutex_unlock(&pinst->lock);
@@ -562,8 +554,6 @@ EXPORT_SYMBOL(padata_start);
  */
 void padata_stop(struct padata_instance *pinst)
 {
-	might_sleep();
-
 	mutex_lock(&pinst->lock);
 	pinst->flags &= ~PADATA_INIT;
 	mutex_unlock(&pinst->lock);
-- 
1.5.6.5

