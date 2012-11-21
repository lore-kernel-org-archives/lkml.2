Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab2KUMre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:47:34 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13491 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2KUMrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:47:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 21 Nov 2012 04:47:32 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>,
        "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 21 Nov 2012 13:47:27 +0100
Subject: Re: [PATCH 1/1] memory: tegra30: Fix warning w/o PM_SLEEP
Thread-Topic: [PATCH 1/1] memory: tegra30: Fix warning w/o PM_SLEEP
Thread-Index: Ac3H5lz2jcutOWTIRS6bGthao+DmIQ==
Message-ID: <20121121.144727.1842286617829159643.hdoyu@nvidia.com>
References: <1353501740-25420-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1353501740-25420-1-git-send-email-hdoyu@nvidia.com>
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

>From 2257f87f95c3982aac7c30389357db66f597c083 Mon Sep 17 00:00:00 2001
From: Hiroshi Doyu <hdoyu@nvidia.com>
Date: Thu, 15 Nov 2012 08:28:39 +0200
Subject: [PATCH 1/1] memory: tegra30: Fix warning w/o PM_SLEEP

Fix build warning w/o PM_SLEEP.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/memory/tegra30-mc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/memory/tegra30-mc.c b/drivers/memory/tegra30-mc.c
index 802b9ea..cf10b77 100644
--- a/drivers/memory/tegra30-mc.c
+++ b/drivers/memory/tegra30-mc.c
@@ -267,6 +267,7 @@ static const u32 tegra30_mc_ctx[] = {
 	MC_INTMASK,
 };
 
+#ifdef CONFIG_PM_SLEEP
 static int tegra30_mc_suspend(struct device *dev)
 {
 	int i;
@@ -290,6 +291,7 @@ static int tegra30_mc_resume(struct device *dev)
 	mc_readl(mc, MC_TIMING_CONTROL);
 	return 0;
 }
+#endif
 
 static UNIVERSAL_DEV_PM_OPS(tegra30_mc_pm,
 			    tegra30_mc_suspend,
-- 
1.7.9.5
