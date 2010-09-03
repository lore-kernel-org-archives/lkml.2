Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab0ICB0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:26:50 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61669 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0ICB0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:26:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=kntagEJUkrN7Pvc5lENGD3uRe5H1gb7Y+q5OXkAq83bxZoA50HydyhLSGkMbj0fjeQ
         MRiDbvhmsUaHYRsEgscoFXTfLzP/ShAwDlzOR/xvYQCmfM8K2vmrhYfKodyXIqnDebnB
         GWwW+73w1CAYgD2TCnILv1xeMohJ+dViXc7a4=
Subject: [PATCH 1/2] Input: stmpe-ts - remove input_free_device() in
	stmpe_ts_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Luotao Fu <l.fu@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain
Date: Fri, 03 Sep 2010 09:30:51 +0800
Message-Id: <1283477451.5439.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to call input_free_device() after input_unregister_device().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/touchscreen/stmpe-ts.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchscreen/stmpe-ts.c
index 656148e..0339d1d 100644
--- a/drivers/input/touchscreen/stmpe-ts.c
+++ b/drivers/input/touchscreen/stmpe-ts.c
@@ -361,7 +361,6 @@ static int __devexit stmpe_ts_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 
 	input_unregister_device(ts->idev);
-	input_free_device(ts->idev);
 
 	kfree(ts);
 
-- 
1.7.2



