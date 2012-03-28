Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2C1GoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:44:25 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:49183 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab2C1GoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:44:23 -0400
Date: Wed, 28 Mar 2012 08:44:07 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 3/3] padata: Fix cpu hotplug
Message-ID: <20120328064407.GG16191@secunet.com>
References: <20120328064157.GD16191@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328064157.GD16191@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Mar 2012 06:44:07.0500 (UTC) FILETIME=[2C8EA0C0:01CD0CAE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't remove the cpu that went offline from our cpumasks
on cpu hotplug. This got lost somewhere along the line, so
restore it. This fixes a hang of the padata instance on cpu
hotplug.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index de3d0d9..89fe3d1 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -748,6 +748,9 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 			return -ENOMEM;
 
 		padata_replace(pinst, pd);
+
+		cpumask_clear_cpu(cpu, pd->cpumask.cbcpu);
+		cpumask_clear_cpu(cpu, pd->cpumask.pcpu);
 	}
 
 	return 0;
-- 
1.7.0.4

