Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1BBS3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:29:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab1BBS3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:29:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=k8z8fq2bERsmeBRab3NgZLqBqrksPCewDtA9c2WSoynmBiAR2p9Vbp0qOEuQI606il
         a0lyYo7G7I9vhFfV63GSY7IenZnWO3Sh+FIKU624MBoDbdLQC0bv0jP6ru8ozx5W2R+z
         FNOfh4OjRdxs2VOsDPY35Y+kF/8510LQdg5/o=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, wwang <wei_wang@realsil.com.cn>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rts_pstor: potential NULL dereference
Date: Wed,  2 Feb 2011 21:29:31 +0300
Message-Id: <1296671372-1612-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_get_bus_and_slot() may return NULL, but the caller checks
wrong variable.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/staging/rts_pstor/rtsx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx.c b/drivers/staging/rts_pstor/rtsx.c
index 9864b1a..2b18379 100644
--- a/drivers/staging/rts_pstor/rtsx.c
+++ b/drivers/staging/rts_pstor/rtsx.c
@@ -334,7 +334,7 @@ int rtsx_read_pci_cfg_byte(u8 bus, u8 dev, u8 func, u8 offset, u8 *val)
 	u8 devfn = (dev << 3) | func;
 
 	pdev = pci_get_bus_and_slot(bus, devfn);
-	if (!dev)
+	if (!pdev)
 		return -1;
 
 	pci_read_config_byte(pdev, offset, &data);
-- 
1.7.0.4

