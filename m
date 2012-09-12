Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab2ILNB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:01:57 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:15608 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152Ab2ILMz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YosZhjkDlV+JM4lUgVg
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511789"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 18/24] Staging: ipack/devices/ipoctal: Check tty_register_device return value.
Date: Wed, 12 Sep 2012 14:55:40 +0200
Message-Id: <1347454546-23236-18-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index b84ab5e..7371270 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -437,6 +437,8 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	ipoctal->tty_drv = tty;
 
 	for (i = 0; i < NR_CHANNELS; i++) {
+		struct device *tty_dev;
+
 		channel = &ipoctal->channel[i];
 		tty_port_init(&channel->tty_port);
 		tty_port_alloc_xmit_buf(&channel->tty_port);
@@ -450,7 +452,11 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		channel->pointer_read = 0;
 		channel->pointer_write = 0;
 		channel->nb_bytes = 0;
-		tty_register_device(tty, i, NULL);
+		tty_dev = tty_register_device(tty, i, NULL);
+		if (IS_ERR(tty_dev)) {
+			dev_err(&ipoctal->dev->dev, "Failed to register tty device.\n");
+			continue;
+		}
 
 		/*
 		 * Enable again the RX. TX will be enabled when
-- 
1.7.10.4

