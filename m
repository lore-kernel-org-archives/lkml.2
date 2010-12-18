Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab0LROyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 09:54:10 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:48882 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756454Ab0LROyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 09:54:08 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Chase Douglas <chase.douglas@canonical.com>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 3/4] Input: synaptics - report clickpad property
Date: Sat, 18 Dec 2010 15:53:00 +0100
Message-Id: <1292683981-6908-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292683981-6908-1-git-send-email-rydberg@euromail.se>
References: <1292683981-6908-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PTyA5-0005hU-4a.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PTyA5-0005hU-4a c043a539d3fdde96080df85b227ca89b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new input property interface, it is possible to report
the special quirks of a device using ioctl/sysfs. This patch
sets up the device as a pointer, and reports the clickpad
functionality via the INPUT_PROP_BUTTONPAD property.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/mouse/synaptics.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 4744064..01302db 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -661,6 +661,8 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 {
 	int i;
 
+	__set_bit(INPUT_PROP_POINTER, dev->propbit);
+
 	__set_bit(EV_ABS, dev->evbit);
 	input_set_abs_params(dev, ABS_X,
 			     XMIN_NOMINAL, priv->x_max ?: XMAX_NOMINAL, 0, 0);
@@ -702,6 +704,7 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 	input_abs_set_res(dev, ABS_Y, priv->y_res);
 
 	if (SYN_CAP_CLICKPAD(priv->ext_cap_0c)) {
+		__set_bit(INPUT_PROP_BUTTONPAD, dev->propbit);
 		/* Clickpads report only left button */
 		__clear_bit(BTN_RIGHT, dev->keybit);
 		__clear_bit(BTN_MIDDLE, dev->keybit);
-- 
1.7.2.3

