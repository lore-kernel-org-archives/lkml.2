Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2LBKZJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 05:25:09 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47188 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2LBKZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 05:25:07 -0500
MIME-Version: 1.0
Date: Sun, 2 Dec 2012 05:25:05 -0500
Message-ID: <CAPgLHd-UekVrvc8gwNUFaoNtcFcZCNC559GW1wfrmUVHidsiOQ@mail.gmail.com>
Subject: [PATCH -next] drm: tegra: fix missing unlock on error
From: Wei Yongjun <weiyj.lk@gmail.com>
To: airlied@linux.ie, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        thierry.reding@avionic-design.de
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function host1x_drm_init()
and host1x_drm_exit() in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/tegra/host1x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/tegra/host1x.c b/drivers/gpu/drm/tegra/host1x.c
index bdb97a5..39629e6 100644
--- a/drivers/gpu/drm/tegra/host1x.c
+++ b/drivers/gpu/drm/tegra/host1x.c
@@ -176,6 +176,7 @@ int host1x_drm_init(struct host1x *host1x, struct drm_device *drm)
 				dev_err(host1x->dev,
 					"DRM setup failed for %s: %d\n",
 					dev_name(client->dev), err);
+				mutex_unlock(&host1x->clients_lock);
 				return err;
 			}
 		}
@@ -203,6 +204,7 @@ int host1x_drm_exit(struct host1x *host1x)
 				dev_err(host1x->dev,
 					"DRM cleanup failed for %s: %d\n",
 					dev_name(client->dev), err);
+				mutex_unlock(&host1x->clients_lock);
 				return err;
 			}
 		}


