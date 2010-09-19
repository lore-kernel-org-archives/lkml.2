Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0ISHWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 03:22:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44555 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751301Ab0ISHWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 03:22:33 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX198YnAAwjR8LuKy+I/wBjLHA36wRBIAssJsMDsWOU
	feNS/T5/WB3W0l
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 06/12] viafb: enable I2C for CRT
Date: Sun, 19 Sep 2010 07:33:47 +0000
Message-Id: <dd6b494198f83d33c7529b3602ae232d18c1227d.1284879532.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <171e0fb74a34b069c0c12aa90c56d5e5da5489c6.1284879532.git.FlorianSchandinat@gmx.de>
References: <171e0fb74a34b069c0c12aa90c56d5e5da5489c6.1284879532.git.FlorianSchandinat@gmx.de>
In-Reply-To: <cover.1284879532.git.FlorianSchandinat@gmx.de>
References: <cover.1284879532.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: enable I2C for CRT

This patch enables the I2C port to talk with the CRT. This allows adding
EDID reading and parsing capability for CRTs.
Just a small preparation, no notable changes in user experience yet.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index 66f4030..69101ab 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -20,7 +20,7 @@
  * The default port config.
  */
 static struct via_port_cfg adap_configs[] = {
-	[VIA_PORT_26]	= { VIA_PORT_I2C,  VIA_MODE_OFF, VIASR, 0x26 },
+	[VIA_PORT_26]	= { VIA_PORT_I2C,  VIA_MODE_I2C, VIASR, 0x26 },
 	[VIA_PORT_31]	= { VIA_PORT_I2C,  VIA_MODE_I2C, VIASR, 0x31 },
 	[VIA_PORT_25]	= { VIA_PORT_GPIO, VIA_MODE_GPIO, VIASR, 0x25 },
 	[VIA_PORT_2C]	= { VIA_PORT_GPIO, VIA_MODE_I2C, VIASR, 0x2c },
-- 
1.6.3.2

