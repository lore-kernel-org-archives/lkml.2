Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab0IBIVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 04:21:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50837 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab0IBIVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 04:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=LapDwCRCjmiNlfANWt1MNQALaZ5XgZURwllz02OyTXaxn1kkDGLax6aLKMgsYbtjGN
         nv4Hd2Gbs1QeVDzJKI71e6tFa9tGUbtZSMBQUj+6O1TWkSjMPly3jrR1Asa6x/R6gpj1
         2Yo5nEJf2JnQofVOIupz9IaU8ZUi/FKKeZtPQ=
Subject: [PATCH] Input: s3c2410_ts - fix s3c2410ts_probe error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Simtec Electronics <linux@simtec.co.uk>, linux-input@vger.kernel.org
Content-Type: text/plain
Date: Thu, 02 Sep 2010 16:25:16 +0800
Message-Id: <1283415916.19272.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use input_free_device() to free devices that have not been registered.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/touchscreen/s3c2410_ts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/s3c2410_ts.c b/drivers/input/touchscreen/s3c2410_ts.c
index 6085d12..8feb7f3 100644
--- a/drivers/input/touchscreen/s3c2410_ts.c
+++ b/drivers/input/touchscreen/s3c2410_ts.c
@@ -350,7 +350,7 @@ static int __devinit s3c2410ts_probe(struct platform_device *pdev)
  err_tcirq:
 	free_irq(ts.irq_tc, ts.input);
  err_inputdev:
-	input_unregister_device(ts.input);
+	input_free_device(ts.input);
  err_iomap:
 	iounmap(ts.io);
  err_clk:
-- 
1.7.2



