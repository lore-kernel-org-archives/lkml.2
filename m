Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab2AHNdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 08:33:37 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57563 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2AHNdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 08:33:31 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [RFC PATCH v2 5/9] ppc: avoid using on_each_cpu hard coded ret value
Date: Sun,  8 Jan 2012 15:32:25 +0200
Message-Id: <1326029549-2794-6-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1326029549-2794-1-git-send-email-gilad@benyossef.com>
References: <1326029549-2794-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on_each_cpu always returns a hard coded return code of zero.

Removing all tests based on this return value saves run time
cycles for compares and code bloat for branches.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Michal Nazarewicz <mina86@mina86.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <rob.herring@calxeda.com>
CC: linuxppc-dev@lists.ozlabs.org
CC: devicetree-discuss@lists.ozlabs.org
---
 arch/powerpc/kernel/rtas.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 517b1d8..829629e 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -850,8 +850,7 @@ int rtas_ibm_suspend_me(struct rtas_args *args)
 	/* Call function on all CPUs.  One of us will make the
 	 * rtas call
 	 */
-	if (on_each_cpu(rtas_percpu_suspend_me, &data, 0))
-		atomic_set(&data.error, -EINVAL);
+	on_each_cpu(rtas_percpu_suspend_me, &data, 0);
 
 	wait_for_completion(&done);
 
-- 
1.7.0.4

