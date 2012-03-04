Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2CDSZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 13:25:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28066 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab2CDSZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 13:25:26 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=4xDcOe4IjvRdPVVETi+CqA==:17 a=TtU46XPs5IkA:10 a=TRgVYD6ZyiEA:10 a=Zx2FLkwYMp0A:10 a=IkcTkHD0fZMA:10 a=yQdBAQUQAAAA:8 a=BM1Bk48kh9kfG9-z95YA:9 a=QEXdDO2ut3YA:10 a=IcxpeKGZWnEA:10 a=4xDcOe4IjvRdPVVETi+CqA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 75.81.36.228
Date: Sun, 04 Mar 2012 12:25:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: awalls@md.metrocast.net
Cc: linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ivtv: Fix build warning
Message-ID: <4f53b393.cBPkBHEECVOO9Jzx%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In driver ivtv, there is a mismatch between the type of the radio module parameter
and the storage variable, which leads to the following warning:

  CC [M]  drivers/media/video/ivtv/ivtv-driver.o
drivers/media/video/ivtv/ivtv-driver.c: In function ‘__check_radio’:
drivers/media/video/ivtv/ivtv-driver.c:142: warning: return from incompatible pointer type
drivers/media/video/ivtv/ivtv-driver.c: At top level:
drivers/media/video/ivtv/ivtv-driver.c:142: warning: initialization from incompatible pointer type

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: linux-2.6/drivers/media/video/ivtv/ivtv-driver.c
===================================================================
--- linux-2.6.orig/drivers/media/video/ivtv/ivtv-driver.c
+++ linux-2.6/drivers/media/video/ivtv/ivtv-driver.c
@@ -99,7 +99,7 @@ static int i2c_clock_period[IVTV_MAX_CAR
 
 static unsigned int cardtype_c = 1;
 static unsigned int tuner_c = 1;
-static bool radio_c = 1;
+static int radio_c = 1;
 static unsigned int i2c_clock_period_c = 1;
 static char pal[] = "---";
 static char secam[] = "--";
@@ -139,7 +139,7 @@ static int tunertype = -1;
 static int newi2c = -1;
 
 module_param_array(tuner, int, &tuner_c, 0644);
-module_param_array(radio, bool, &radio_c, 0644);
+module_param_array(radio, int, &radio_c, 0644);
 module_param_array(cardtype, int, &cardtype_c, 0644);
 module_param_string(pal, pal, sizeof(pal), 0644);
 module_param_string(secam, secam, sizeof(secam), 0644);
