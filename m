Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab2DYQcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:32:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57811 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab2DYQcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:32:23 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: propagate map validation errors
Date: Wed, 25 Apr 2012 10:32:16 -0600
Message-Id: <1335371536-24072-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

pinctrl_register_map() was returning early if pinmux_validate_map() or
pinconf_validate_map() failed, but was not actually returning the error
code.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 5cd5a5a..913c83e 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -911,13 +911,13 @@ int pinctrl_register_map(struct pinctrl_map const *maps, unsigned num_maps,
 		case PIN_MAP_TYPE_MUX_GROUP:
 			ret = pinmux_validate_map(&maps[i], i);
 			if (ret < 0)
-				return 0;
+				return ret;
 			break;
 		case PIN_MAP_TYPE_CONFIGS_PIN:
 		case PIN_MAP_TYPE_CONFIGS_GROUP:
 			ret = pinconf_validate_map(&maps[i], i);
 			if (ret < 0)
-				return 0;
+				return ret;
 			break;
 		default:
 			pr_err("failed to register map %s (%d): invalid type given\n",
-- 
1.7.0.4

