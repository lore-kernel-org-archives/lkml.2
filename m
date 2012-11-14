Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab2KNF4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:56:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55233 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756420Ab2KNFvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:51:02 -0500
Message-Id: <20121114053939.419144308@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:13 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 40/82] Input: tsc40 - remove wrong announcement of pressure support
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
 


