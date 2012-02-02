Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab2BBOxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:53:13 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:58269 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab2BBOxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:53:09 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3 v2] drivers/power/pda_power.c: Move call to PTR_ERR after reassignment
Date: Thu,  2 Feb 2012 15:53:00 +0100
Message-Id: <1328194382-32465-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1328194382-32465-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1328194382-32465-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

PTR_ERR should be called before its argument is cleared.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,e1;
constant c;
@@

*e = c
... when != e = e1
    when != &e
    when != true IS_ERR(e)
*PTR_ERR(e)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Reported-by: Josh Triplett <josh@joshtriplett.org>

---
This patch probably only half way solves the problem with this code.  It would
seem that it should have a goto at the end, but I am not sure to where.

v2: correct commit message.

 drivers/power/pda_power.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index fd49689..16611c3 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -316,8 +316,8 @@ static int pda_power_probe(struct platform_device *pdev)
 	ac_draw = regulator_get(dev, "ac_draw");
 	if (IS_ERR(ac_draw)) {
 		dev_dbg(dev, "couldn't get ac_draw regulator\n");
-		ac_draw = NULL;
 		ret = PTR_ERR(ac_draw);
+		ac_draw = NULL;
 	}
 
 #ifdef CONFIG_USB_OTG_UTILS

