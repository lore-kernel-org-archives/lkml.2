Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab2KPE63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 23:58:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6332 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab2KPE61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 23:58:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 15 Nov 2012 20:58:21 -0800
From: Mark Zhang <markz@nvidia.com>
To: <airlied@redhat.com>, <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, Mark Zhang <markz@nvidia.com>
Subject: [PATCH] drm: Add NVIDIA Tegra30 support
Date: Fri, 16 Nov 2012 12:58:09 +0800
Message-ID: <1353041889-3114-1-git-send-email-markz@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is based on Thierry's drm patch for Tegra20:
- [PATCH v2 0/6] Device tree updates for host1x support
- [PATCH v3 0/2] NVIDIA Tegra DRM driver

It adds the support for NVIDIA Tegra30.

Signed-off-by: Mark Zhang <markz@nvidia.com>
---
 drivers/gpu/drm/tegra/dc.c     |    1 +
 drivers/gpu/drm/tegra/host1x.c |    3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 216cd0f..6e9f1b4 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -819,6 +819,7 @@ static int tegra_dc_remove(struct platform_device *pdev)
 
 static struct of_device_id tegra_dc_of_match[] = {
        { .compatible = "nvidia,tegra20-dc", },
+	{ .compatible = "nvidia,tegra30-dc", },
        { },
 };
 
diff --git a/drivers/gpu/drm/tegra/host1x.c b/drivers/gpu/drm/tegra/host1x.c
index 3d02554..07b7e27 100644
--- a/drivers/gpu/drm/tegra/host1x.c
+++ b/drivers/gpu/drm/tegra/host1x.c
@@ -68,6 +68,8 @@ static int host1x_parse_dt(struct host1x *host1x)
        static const char * const compat[] = {
                "nvidia,tegra20-dc",
                "nvidia,tegra20-hdmi",
+		"nvidia,tegra30-dc",
+		"nvidia,tegra30-hdmi",
        };
        unsigned int i;
        int err;
@@ -269,6 +271,7 @@ int host1x_unregister_client(struct host1x *host1x,
 
 static struct of_device_id tegra_host1x_of_match[] = {
        { .compatible = "nvidia,tegra20-host1x", },
+	{ .compatible = "nvidia,tegra30-host1x", },
        { },
 };
 MODULE_DEVICE_TABLE(of, tegra_host1x_of_match);
-- 
1.7.9.5

