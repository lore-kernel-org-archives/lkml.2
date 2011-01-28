Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1A1Wa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 17:30:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab1A1Wa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 17:30:27 -0500
From: Stefan Weil <weil@mail.berlios.de>
To: jon.mason@exar.com
Cc: Stefan Weil <weil@mail.berlios.de>,
        Ramkrishna Vepa <ramkrishna.vepa@exar.com>,
        Sivakumar Subramani <sivakumar.subramani@exar.com>,
        Sreenivasa Honnur <sreenivasa.honnur@exar.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vxge: Fix wrong boolean operator
Date: Fri, 28 Jan 2011 23:30:17 +0100
Message-Id: <1296253817-7668-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:YHxnPUYuOEGPKm1eQbjXvoZZGx2aZsrCxnUQhv0jJn8
 coHsuuZNTn2lKTlKG9WK/QUM9tetFn60Zhc5UtL6iwjcnPyFJU
 PuQKk2kJWZZK6ci09/inks+zw79YLazimzie/Bia0TnWqiwXf7
 Z6U8mlboY+FQ9reAw3pwgTL9vUTi09CGyb9nf7FWfqDgOFFzsi
 1FAmFr6F+m4FZzkpsFlmtU3RF+wQxVNqQHN8sdvhElph+6AlA4
 t8HjNEUZlRobr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This error is reported by cppcheck:
drivers/net/vxge/vxge-config.c:3693: warning: Mutual exclusion over || always evaluates to true. Did you intend to use && instead?

It looks like cppcheck is correct, so fix this. No test was run.

Cc: Ramkrishna Vepa <ramkrishna.vepa@exar.com>
Cc: Sivakumar Subramani <sivakumar.subramani@exar.com>
Cc: Sreenivasa Honnur <sreenivasa.honnur@exar.com>
Cc: Jon Mason <jon.mason@exar.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 drivers/net/vxge/vxge-config.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/vxge/vxge-config.c b/drivers/net/vxge/vxge-config.c
index 01c05f5..228d4f7 100644
--- a/drivers/net/vxge/vxge-config.c
+++ b/drivers/net/vxge/vxge-config.c
@@ -3690,7 +3690,7 @@ __vxge_hw_vpath_rts_table_get(struct __vxge_hw_vpath_handle *vp,
 	if (status != VXGE_HW_OK)
 		goto exit;
 
-	if ((rts_table != VXGE_HW_RTS_ACCESS_STEER_CTRL_DATA_STRUCT_SEL_DA) ||
+	if ((rts_table != VXGE_HW_RTS_ACCESS_STEER_CTRL_DATA_STRUCT_SEL_DA) &&
 	    (rts_table !=
 	     VXGE_HW_RTS_ACS_STEER_CTRL_DATA_STRUCT_SEL_RTH_MULTI_IT))
 		*data1 = 0;
-- 
1.7.2.3

