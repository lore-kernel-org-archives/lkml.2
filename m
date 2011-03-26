Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1CZSYK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 14:24:10 -0400
Received: from unix.wroclaw.pl ([94.23.28.62]:58859 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab1CZSYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 14:24:08 -0400
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Patrick Boettcher <patrick.boettcher@dibcom.fr>,
        Olivier Grenie <olivier.grenie@dibcom.fr>,
        Wolfram Sang <w.sang@pengutronix.de>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] [media] dib0700: fix possible NULL pointer dereference
Date: Sat, 26 Mar 2011 19:23:56 +0100
Message-Id: <1301163836-7601-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: git-send-email 1.7.0.4
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems like 'adap->fe' test for NULL was meant to be before we dereference
that pointer.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 97af266..b48f1e0 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -2439,12 +2439,11 @@ static int tfe7090pvr_frontend0_attach(struct dvb_usb_adapter *adap)
 
 	dib0700_set_i2c_speed(adap->dev, 340);
 	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x90, &tfe7090pvr_dib7000p_config[0]);
-
-	dib7090_slave_reset(adap->fe);
-
 	if (adap->fe == NULL)
 		return -ENODEV;
 
+	dib7090_slave_reset(adap->fe);
+
 	return 0;
 }
 
-- 
1.7.0.4

