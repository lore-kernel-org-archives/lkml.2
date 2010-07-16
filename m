Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935470Ab0GPCnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:43:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46044 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935363Ab0GPCnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:43:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=lNksRsJ6GTtNd6pqV6HdojdEXFcn02R3qymRL0XOc6JS1NKDj7NnlU2F1/qqKX/lEk
         EVuIuZoywXHciSpTqYAUBllktjMe9ft646qLvQlROFkEqJKo6dd6NpQIko4SmkaE3POq
         j7M08Lw+S/IfDUUVjenO5w84pSUA2/P/RbcY8=
Message-ID: <4C3FC736.4010805@gmail.com>
Date: Fri, 16 Jul 2010 10:43:02 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] touchscreen/nuc900: fix wrong setup_timer parameter
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

This patch fixes wrong setup_timer parameter,when pen up event coming
all codes quoting the w90p910_ts work failed.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
---
 drivers/input/touchscreen/w90p910_ts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/w90p910_ts.c b/drivers/input/touchscreen/w90p910_ts.c
index cc18265..7a45d68 100644
--- a/drivers/input/touchscreen/w90p910_ts.c
+++ b/drivers/input/touchscreen/w90p910_ts.c
@@ -233,7 +233,7 @@ static int __devinit w90x900ts_probe(struct platform_device *pdev)
 	w90p910_ts->state = TS_IDLE;
 	spin_lock_init(&w90p910_ts->lock);
 	setup_timer(&w90p910_ts->timer, w90p910_check_pen_up,
-		    (unsigned long)&w90p910_ts);
+		    (unsigned long)w90p910_ts);

 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
-- 
1.6.3.3
