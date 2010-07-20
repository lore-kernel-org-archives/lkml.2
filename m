Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab0GTGs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 02:48:28 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:49314 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924Ab0GTGsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 02:48:25 -0400
Date: Tue, 20 Jul 2010 08:51:25 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] padata: Check for valid cpumasks
Message-ID: <20100720065125.GE11081@secunet.com>
References: <20100714142951.22817d0c@leibniz>
 <20100719060426.GA19696@gondor.apana.org.au>
 <20100719064050.GA11081@secunet.com>
 <20100719073255.GA20403@gondor.apana.org.au>
 <20100720064736.GB11081@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100720064736.GB11081@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 20 Jul 2010 06:48:23.0737 (UTC) FILETIME=[8C698A90:01CB27D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we allow to change the cpumasks from userspace, we have
to check for valid cpumasks in padata_do_parallel. This patch adds
the necessary check. This fixes a division by zero crash if the
parallel cpumask contains no active cpu.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 6a51945..7f895e2 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -114,7 +114,7 @@ int padata_do_parallel(struct padata_instance *pinst,
 	pd = rcu_dereference(pinst->pd);
 
 	err = -EINVAL;
-	if (!(pinst->flags & PADATA_INIT))
+	if (!(pinst->flags & PADATA_INIT) || pinst->flags & PADATA_INVALID)
 		goto out;
 
 	if (!cpumask_test_cpu(cb_cpu, pd->cpumask.cbcpu))
-- 
1.5.6.5

