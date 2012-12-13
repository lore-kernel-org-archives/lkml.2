Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2LMOCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:02:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44091 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab2LMOCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:02:39 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 031/241] Input: tsc40 - remove wrong announcement of pressure support
Date: Thu, 13 Dec 2012 11:56:36 -0200
Message-Id: <1355407206-17100-32-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

commit 32ed1911fc79908d704023317d4ddeb3883fd07e upstream.

The tsc40 driver announces it supports the pressure event, but will never
send one. The announcement will cause tslib to wait for such events and
sending all touch events with a pressure of 0. Removing the announcement
will make tslib fall back to emulating the pressure on touch events so
everything works as expected.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/input/touchscreen/tsc40.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/input/touchscreen/tsc40.c b/drivers/input/touchscreen/tsc40.c
index 63209aa..eb96f16 100644
--- a/drivers/input/touchscreen/tsc40.c
+++ b/drivers/input/touchscreen/tsc40.c
@@ -107,7 +107,6 @@ static int tsc_connect(struct serio *serio, struct serio_driver *drv)
 	__set_bit(BTN_TOUCH, input_dev->keybit);
 	input_set_abs_params(ptsc->dev, ABS_X, 0, 0x3ff, 0, 0);
 	input_set_abs_params(ptsc->dev, ABS_Y, 0, 0x3ff, 0, 0);
-	input_set_abs_params(ptsc->dev, ABS_PRESSURE, 0, 0, 0, 0);
 
 	serio_set_drvdata(serio, ptsc);
 
-- 
1.7.9.5

