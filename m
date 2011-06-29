Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1F2FI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:08:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60253 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1F2FIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:08:00 -0400
From: djkurtz@chromium.org
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        chase.douglas@canonical.com, rubini@cvml.unipv.it
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 04/12] Input: synaptics - set resolution for MT_POSITION_X/Y axes
Date: Wed, 29 Jun 2011 13:07:14 +0800
Message-Id: <1309324042-22943-5-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

Set resolution for MT_POSITION_X and MT_POSITION_Y to match ABS_X and
ABS_Y, respectively.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/mouse/synaptics.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index a4b7801..1ce47b7 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -703,6 +703,9 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
 				     priv->x_max ?: XMAX_NOMINAL, 0, 0);
 		input_set_abs_params(dev, ABS_MT_POSITION_Y, YMIN_NOMINAL,
 				     priv->y_max ?: YMAX_NOMINAL, 0, 0);
+
+		input_abs_set_res(dev, ABS_MT_POSITION_X, priv->x_res);
+		input_abs_set_res(dev, ABS_MT_POSITION_Y, priv->y_res);
 	}
 
 	if (SYN_CAP_PALMDETECT(priv->capabilities))
-- 
1.7.3.1

