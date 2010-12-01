Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0LAPEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:04:47 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51685 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0LAPEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:04:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vXfHDOIUvkS7a3Zzn9FAZ9RR5FrVLbRiZPDttfdYkM1zH+++mjHizHzf2kWOmmgalN
         EY41hhFpeLt+9F7PTyp9Iq/LEx83YXW0TkQG9UzTLvgyWGKHXGdB8wtGLHRizG6SXitt
         pFc9iJGXK8xfIKnLk7/gjK7Rf2MeODS/+GaPk=
From: Namhyung Kim <namhyung@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Input: xpad - fix memory leak
Date: Thu,  2 Dec 2010 00:04:33 +0900
Message-Id: <1291215874-5625-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xpad->bdata was dynamically allocated but never freed. Since it is
used for xpad->bulk_out->transfer_buffer, set URB_FREE_BUFFER flag
in order to get freed when usb_free_urb() called.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/input/joystick/xpad.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index f9fb7fa..f885902 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -955,6 +955,7 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 		usb_fill_bulk_urb(xpad->bulk_out, udev,
 				usb_sndbulkpipe(udev, ep_irq_in->bEndpointAddress),
 				xpad->bdata, XPAD_PKT_LEN, xpad_bulk_out, xpad);
+		xpad->bulk_out->transfer_flags |= URB_FREE_BUFFER;
 	}
 
 	return 0;
-- 
1.7.0.4

