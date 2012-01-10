Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab2AJRWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:22:13 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:36062 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab2AJRWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:22:11 -0500
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jan 2012 12:22:10 EST
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@infradead.org
Cc: mikekrufky@gmail.com, linux-media@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 2/4] DVB: dib0700, separate stk7070pd initialization
Date: Tue, 10 Jan 2012 18:11:23 +0100
Message-Id: <1326215485-20846-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1326215485-20846-1-git-send-email-jslaby@suse.cz>
References: <1326215485-20846-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The start is common for both stk7070pd and novatd specific routine.
This is just a preparation for the next patch.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 3c6ee54..e5c2bd2 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -3066,19 +3066,25 @@ static struct dib7000p_config stk7070pd_dib7000p_config[2] = {
 	}
 };
 
-static int stk7070pd_frontend_attach0(struct dvb_usb_adapter *adap)
+static void stk7070pd_init(struct dvb_usb_device *dev)
 {
-	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
+	dib0700_set_gpio(dev, GPIO6, GPIO_OUT, 1);
 	msleep(10);
-	dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
-	dib0700_set_gpio(adap->dev, GPIO4, GPIO_OUT, 1);
-	dib0700_set_gpio(adap->dev, GPIO7, GPIO_OUT, 1);
-	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);
+	dib0700_set_gpio(dev, GPIO9, GPIO_OUT, 1);
+	dib0700_set_gpio(dev, GPIO4, GPIO_OUT, 1);
+	dib0700_set_gpio(dev, GPIO7, GPIO_OUT, 1);
+	dib0700_set_gpio(dev, GPIO10, GPIO_OUT, 0);
 
-	dib0700_ctrl_clock(adap->dev, 72, 1);
+	dib0700_ctrl_clock(dev, 72, 1);
 
 	msleep(10);
-	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
+	dib0700_set_gpio(dev, GPIO10, GPIO_OUT, 1);
+}
+
+static int stk7070pd_frontend_attach0(struct dvb_usb_adapter *adap)
+{
+	stk7070pd_init(adap->dev);
+
 	msleep(10);
 	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
 
-- 
1.7.8


