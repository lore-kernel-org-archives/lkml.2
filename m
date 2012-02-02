Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab2BBOA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:00:56 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:33040 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421Ab2BBOAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:00:55 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org, josh@joshtriplett.org
Cc: kernel-janitors@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: [PATCH 1/3] drivers/power/pda_power.c: Move call to PTR_ERR after reassignment
Date: Thu,  2 Feb 2012 15:00:45 +0100
Message-Id: <1328191247-23792-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1328191247-23792-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1328191247-23792-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.

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

Signed-off-by: Julia Lawall <julia@diku.dk>
Reported-by: Josh Triplett <josh@joshtriplett.org>

---
This patch probably only half way solves the problem with this code.  It would
seem that it should have a goto at the end, but I am not sure to where.

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

