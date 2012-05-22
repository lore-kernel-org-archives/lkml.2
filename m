Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686Ab2EVWUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:20:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52983 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2EVWUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:20:19 -0400
Date: Wed, 23 May 2012 00:20:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Linus Walleij <linus.walleij@linaro.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: fix a minor harmless typo
Message-ID: <Pine.LNX.4.64.1205230019070.11851@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:XPD6sh9ssnHjbDbPKFnMgSS7cOQoNZBSnFh0FSHYgqh
 qvyMoIp+9hVhi+17gby4eBOUe9HjgkswcLpjSrxbDVhEToDnLr
 fVP1vuuJJ8NE31GB7WvgG0IRtCdxSJyJplDnjJIUheBSAAefap
 hhFXKH4m5KSRqyXuarUHRsIZh/xIYkObiZ5o+N60rmgCTEhYeN
 75Amtr3TDy6hQs3OwQOg0NonEfZKdRlTNAOyrwjN8Vi4NYQlEK
 j9ddFapbaFwtA9OTsuQv0MIJ9hu1LoQ1b90xucng95cdmxpcgb
 5LB8mACy/P0DTksDR59qdKbj38AnFW5OJvLWTYn8he0F405nWt
 Zbd564sQGe3sQ59tmGJthEOyKawy2omMstXLiNVRZRTD/Ogdwi
 rK0nXjh4nM1xA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way the for_each_maps() macro is currently used, using "i" instead of
"_i_" works and is harmless. Still, this is a bug, that can trigger any
time, if the code around that macro changes. Better fix it now.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index ec3b8cc18..4e768d4 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -57,7 +57,7 @@ static LIST_HEAD(pinctrl_maps);
 	list_for_each_entry(_maps_node_, &pinctrl_maps, node) \
 		for (_i_ = 0, _map_ = &_maps_node_->maps[_i_]; \
 			_i_ < _maps_node_->num_maps; \
-			i++, _map_ = &_maps_node_->maps[_i_])
+			_i_++, _map_ = &_maps_node_->maps[_i_])
 
 /**
  * pinctrl_provide_dummies() - indicate if pinctrl provides dummy state support
