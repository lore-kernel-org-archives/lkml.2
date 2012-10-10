Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab2JKAWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:22:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51759 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932511Ab2JKAWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:22:32 -0400
X-Sasl-enc: cdqWk9PdnvJBrkHdMjeGxZOp5lwDQ8ncFf5VlET1BGIT 1349914951
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 106/122] em28xx: regression fix: use DRX-K sync firmware requests on em28xx
Date: Thu, 11 Oct 2012 07:54:32 +0900
Message-Id: <20121010225357.097040098@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 2425bb3d4016ed95ce83a90b53bd92c7f31091e4 upstream.

As em28xx-dvb will always be initialized asynchronously, there's
no need anymore for a separate thread to load the DRX-K firmware.

Fixes a known regression with kernel 3.6 with tda18271 driver
and asynchronous DRX-K firmware load.

Antti tested it with the following hardware:
        Hauppauge WinTV HVR 930C
        MaxMedia UB425-TC
        PCTV QuatroStick nano (520e)

Tested-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/em28xx/em28xx-dvb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -316,6 +316,7 @@ static struct drxk_config terratec_h5_dr
 	.no_i2c_bridge = 1,
 	.microcode_name = "dvb-usb-terratec-h5-drxk.fw",
 	.qam_demod_parameter_count = 2,
+	.load_firmware_sync = true,
 };
 
 static struct drxk_config hauppauge_930c_drxk = {
@@ -325,6 +326,7 @@ static struct drxk_config hauppauge_930c
 	.microcode_name = "dvb-usb-hauppauge-hvr930c-drxk.fw",
 	.chunk_size = 56,
 	.qam_demod_parameter_count = 2,
+	.load_firmware_sync = true,
 };
 
 struct drxk_config terratec_htc_stick_drxk = {
@@ -338,12 +340,14 @@ struct drxk_config terratec_htc_stick_dr
 	.antenna_dvbt = true,
 	/* The windows driver uses the same. This will disable LNA. */
 	.antenna_gpio = 0x6,
+	.load_firmware_sync = true,
 };
 
 static struct drxk_config maxmedia_ub425_tc_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
 	.no_i2c_bridge = 1,
+	.load_firmware_sync = true,
 };
 
 static struct drxk_config pctv_520e_drxk = {
@@ -354,6 +358,7 @@ static struct drxk_config pctv_520e_drxk
 	.chunk_size = 58,
 	.antenna_dvbt = true, /* disable LNA */
 	.antenna_gpio = (1 << 2), /* disable LNA */
+	.load_firmware_sync = true,
 };
 
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)


