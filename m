Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab0ICB2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:28:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46494 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0ICB2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IoQy/BDgsNX6Lk5m6v99F8Wt4Sv/aTZd3s640ZhohZph+YTI9Wjh6+gq2P63MG0z2x
         xLvNEkYD0r8U5AsCjFWoTd3yjxUdPpSPxa/x2yatf1xwdIgSbWXyRPYvqG1hRQEDcp8B
         l6taXnPAgxaMNsDq+c/xgWbqFOoyIw/pYd6qk=
Subject: [PATCH 2/2] Input: stmpe-ts - return -ENOMEM if memory allocation
	fail
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Luotao Fu <l.fu@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
In-Reply-To: <1283477451.5439.6.camel@mola>
References: <1283477451.5439.6.camel@mola>
Content-Type: text/plain
Date: Fri, 03 Sep 2010 09:32:13 +0800
Message-Id: <1283477533.5439.8.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/touchscreen/stmpe-ts.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchscreen/stmpe-ts.c
index 0339d1d..e715b27 100644
--- a/drivers/input/touchscreen/stmpe-ts.c
+++ b/drivers/input/touchscreen/stmpe-ts.c
@@ -276,12 +276,16 @@ static int __devinit stmpe_input_probe(struct platform_device *pdev)
 		return ts_irq;
 
 	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
-	if (!ts)
+	if (!ts) {
+		ret = -ENOMEM;
 		goto err_out;
+	}
 
 	idev = input_allocate_device();
-	if (!idev)
+	if (!idev) {
+		ret = -ENOMEM;
 		goto err_free_ts;
+	}
 
 	platform_set_drvdata(pdev, ts);
 	ts->stmpe = stmpe;
-- 
1.7.2



