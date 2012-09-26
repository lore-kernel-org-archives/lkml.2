Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab2IZTHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 15:07:42 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40591 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab2IZTHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 15:07:41 -0400
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] pinctrl: pinctrl-single: add debugfs pin h/w state info
Date: Wed, 26 Sep 2012 15:07:43 -0400
Message-Id: <1348686463-25793-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for displaying the individual pin h/w config state.

Signed-off-by: Matt Porter <mporter@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 drivers/pinctrl/pinctrl-single.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index aabecfa..726a729 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -246,7 +246,15 @@ static void pcs_pin_dbg_show(struct pinctrl_dev *pctldev,
 					struct seq_file *s,
 					unsigned offset)
 {
-	seq_printf(s, " " DRIVER_NAME);
+	struct pcs_device *pcs;
+	unsigned val;
+
+	pcs = pinctrl_dev_get_drvdata(pctldev);
+
+	val = pcs->read(pcs->base + offset);
+	val &= pcs->fmask;
+
+	seq_printf(s, "%08x %s " , val, DRIVER_NAME);
 }
 
 static void pcs_dt_free_map(struct pinctrl_dev *pctldev,
-- 
1.7.9.5

