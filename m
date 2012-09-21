Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2IUBCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 21:02:14 -0400
Received: from nm21.bullet.mail.ird.yahoo.com ([212.82.108.136]:33785 "HELO
	nm21.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753351Ab2IUBCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 21:02:13 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Sep 2012 21:02:13 EDT
X-Yahoo-Newman-Id: 765765.47838.bm@smtp148.mail.ird.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: d4CXAbIVM1lA4Xay.nzMmQppNtB1HnuwDdPrgs2HnItp9_O
 KHeVrQxZmb8OitRC6EoH0jvKly.9U8_LntWKuUcx8XnTTDMvpHBoGipzODFM
 6X2HKpFJ9L7ueD4V6b3TAjzJzxAtbmJrSSJCtgDWOkoqs5ifd0GX2DHBUkDR
 3V5SnP5ujv2qFUzIOguAFNB6iodvap1qEEL5p3QUgL.e3aRYE5sSWrfyNfdr
 igvKw2oV852yoqO.xAMv65deU35ouRkjJJkYaUiQOpZE9vIJ5PWtzRgOhDKS
 cgshV6tv9k6yKi4LusRs1plztykAcyLLAhnt48OzixSuBHK7UucyerEtTnyN
 z0khY7_59U2anOrLDYgxnx4gqUkzJm1m_aJc.a.nAOpbrXYSkU6ICVvKyCfi
 6nocD_0AOQXeKl7I9MYyo
X-Yahoo-SMTP: 5Vuzu2WswBCxMnJ0hjKohBcp6M6Es6bt5AQ-
Message-ID: <505BBB4B.3060508@yahoo.com>
Date: Fri, 21 Sep 2012 01:56:43 +0100
From: Paul Parsons <lost.distance@yahoo.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: cbou@mail.ru, dwmw2@infradead.org
CC: philipp.zabel@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] pda_power: remove ac_draw_failed goto and label
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A previous patch added the ac_draw_failed goto and label to
pda_power_probe(). The goto would be invoked after a failed call to
regulator_get().

However the way ac_draw is used - always after a check for NULL -
suggests that a failed call to regulator_get() was not fatal.

This patch removes the ac_draw_failed goto and label, partly reverting
the previous patch.

This patch also removes the assignment of an error code to ret after a
failed call to regulator_get(), since the error code is now never used.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
---
  drivers/power/pda_power.c |    3 ---
  1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index d3be834d..7df7c5f 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -284,9 +284,7 @@ static int pda_power_probe(struct platform_device *pdev)
  	ac_draw = regulator_get(dev, "ac_draw");
  	if (IS_ERR(ac_draw)) {
  		dev_dbg(dev, "couldn't get ac_draw regulator\n");
-		ret = PTR_ERR(ac_draw);
  		ac_draw = NULL;
-		goto ac_draw_failed;
  	}

  	update_status();
@@ -416,7 +414,6 @@ ac_supply_failed:
  		regulator_put(ac_draw);
  		ac_draw = NULL;
  	}
-ac_draw_failed:
  	if (pdata->exit)
  		pdata->exit(dev);
  init_failed:
-- 
1.7.8.6

