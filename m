Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab2LDFUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 00:20:33 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:40061 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2LDFUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 00:20:32 -0500
MIME-Version: 1.0
Date: Tue, 4 Dec 2012 00:20:31 -0500
Message-ID: <CAPgLHd-4S=mcXuNzs9ULZ7KZ3cs95Z2OevoOZsWt4-G0oFa+cw@mail.gmail.com>
Subject: [PATCH -next] powerpc/82xx: use for_each_compatible_node() macro
From: Wei Yongjun <weiyj.lk@gmail.com>
To: benh@kernel.crashing.org, paulus@samba.org
Cc: yongjun_wei@trendmicro.com.cn, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use for_each_compatible_node() macro instead of open coding it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/powerpc/platforms/82xx/pq2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/82xx/pq2.c b/arch/powerpc/platforms/82xx/pq2.c
index fb94d10..fc8b2d6 100644
--- a/arch/powerpc/platforms/82xx/pq2.c
+++ b/arch/powerpc/platforms/82xx/pq2.c
@@ -71,11 +71,11 @@ err:
 
 void __init pq2_init_pci(void)
 {
-	struct device_node *np = NULL;
+	struct device_node *np;
 
 	ppc_md.pci_exclude_device = pq2_pci_exclude_device;
 
-	while ((np = of_find_compatible_node(np, NULL, "fsl,pq2-pci")))
+	for_each_compatible_node(np, NULL, "fsl,pq2-pci")
 		pq2_pci_add_bridge(np);
 }
 #endif


