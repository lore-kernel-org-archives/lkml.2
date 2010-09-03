Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab0ICBEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:04:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64308 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab0ICBEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:04:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ddCVtk530sddpeUJxlpNe52KjVzzt00EQfjBbhj1LhROC2xQN97s5Ru8bG/BrzdF56
         dWZprNIBnlcAo+EU4ZwTIR8Tm1QSrfEgJnP3mhuc5Ow1pND6xgyBCU5nszxa70Qsbh0w
         rMf+6GMLKXvZgvG1kAEA0O1E24QUOWQMUcY3U=
Subject: [PATCH] Input: tps6507x-ts - call input_unregister_device instead
	of input_free_device in tps6507x_ts_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Todd Fischer <todd.fischer@ridgerun.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain
Date: Fri, 03 Sep 2010 09:08:07 +0800
Message-Id: <1283476087.5439.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/touchscreen/tps6507x-ts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
index 7286209..c8c136c 100644
--- a/drivers/input/touchscreen/tps6507x-ts.c
+++ b/drivers/input/touchscreen/tps6507x-ts.c
@@ -359,7 +359,7 @@ static int __devexit tps6507x_ts_remove(struct platform_device *pdev)
 	cancel_delayed_work_sync(&tsc->work);
 	destroy_workqueue(tsc->wq);
 
-	input_free_device(input_dev);
+	input_unregister_device(input_dev);
 
 	tps6507x_dev->ts = NULL;
 	kfree(tsc);
-- 
1.7.2



