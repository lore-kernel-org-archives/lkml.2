Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992844Ab2KOEK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:10:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:48720 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992828Ab2KOEKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:10:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 04/66] Input: tsc40 - remove wrong announcement of pressure support
Date: Wed, 14 Nov 2012 20:10:09 -0800
Message-Id: <20121115040939.335512911@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/touchscreen/tsc40.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/input/touchscreen/tsc40.c
+++ b/drivers/input/touchscreen/tsc40.c
@@ -107,7 +107,6 @@ static int tsc_connect(struct serio *ser
 	__set_bit(BTN_TOUCH, input_dev->keybit);
 	input_set_abs_params(ptsc->dev, ABS_X, 0, 0x3ff, 0, 0);
 	input_set_abs_params(ptsc->dev, ABS_Y, 0, 0x3ff, 0, 0);
-	input_set_abs_params(ptsc->dev, ABS_PRESSURE, 0, 0, 0, 0);
 
 	serio_set_drvdata(serio, ptsc);
 


