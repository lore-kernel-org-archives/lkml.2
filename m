Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab0E0Mcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:32:32 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48500 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab0E0Mca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:32:30 -0400
Date: Thu, 27 May 2010 14:32:24 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/11] drivers/watchdog: Eliminate a NULL pointer dereference
Message-ID: <Pine.LNX.4.64.1005271432100.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

At the point of the call to dev_err, wm8350 is NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E,E1;
identifier f;
statement S1,S2,S3;
@@

if ((E == NULL && ...) || ...)
{
  ... when != if (...) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/watchdog/wm8350_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
index 89dd7b0..b68d928 100644
--- a/drivers/watchdog/wm8350_wdt.c
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -284,7 +284,7 @@ static int __devinit wm8350_wdt_probe(struct platform_device *pdev)
 	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
 
 	if (!wm8350) {
-		dev_err(wm8350->dev, "No driver data supplied\n");
+		pr_err("No driver data supplied\n");
 		return -ENODEV;
 	}
 
