Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2KUMqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:46:44 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13433 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2KUMqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:46:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 21 Nov 2012 04:46:42 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 21 Nov 2012 13:46:37 +0100
Subject: Re: [PATCH 1/1] amba: tegra-ahb: Fix warning w/o PM_SLEEP
Thread-Topic: [PATCH 1/1] amba: tegra-ahb: Fix warning w/o PM_SLEEP
Thread-Index: Ac3H5kBJjAhH5r8RQja0a+DE77v2eg==
Message-ID: <20121121.144637.924356344656100182.hdoyu@nvidia.com>
References: <1353501697-25345-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1353501697-25345-1-git-send-email-hdoyu@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From cd21894b640d456974920247d2a10421e78ba960 Mon Sep 17 00:00:00 2001
From: Hiroshi Doyu <hdoyu@nvidia.com>
Date: Thu, 15 Nov 2012 08:27:41 +0200
Subject: [PATCH 1/1] amba: tegra-ahb: Fix warning w/o PM_SLEEP

Fix build warning w/o PM_SLEEP.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/amba/tegra-ahb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/amba/tegra-ahb.c b/drivers/amba/tegra-ahb.c
index bd5de08..0576a7d 100644
--- a/drivers/amba/tegra-ahb.c
+++ b/drivers/amba/tegra-ahb.c
@@ -157,6 +157,7 @@ int tegra_ahb_enable_smmu(struct device_node *dn)
 EXPORT_SYMBOL(tegra_ahb_enable_smmu);
 #endif
 
+#ifdef CONFIG_PM_SLEEP
 static int tegra_ahb_suspend(struct device *dev)
 {
 	int i;
@@ -176,6 +177,7 @@ static int tegra_ahb_resume(struct device *dev)
 		gizmo_writel(ahb, ahb->ctx[i], tegra_ahb_gizmo[i]);
 	return 0;
 }
+#endif
 
 static UNIVERSAL_DEV_PM_OPS(tegra_ahb_pm,
 			    tegra_ahb_suspend,
-- 
1.7.9.5
