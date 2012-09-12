Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab2IMABF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:01:05 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58620 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab2ILXlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:41:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Sven Schnelle <svens@stackframe.org>
Subject: [ 60/85] USB: CDC ACM: Fix NULL pointer dereference
Date: Wed, 12 Sep 2012 16:36:43 -0700
Message-Id: <20120912233548.026924705@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@stackframe.org>

commit 99f347caa4568cb803862730b3b1f1942639523f upstream.

If a device specifies zero endpoints in its interface descriptor,
the kernel oopses in acm_probe(). Even though that's clearly an
invalid descriptor, we should test wether we have all endpoints.
This is especially bad as this oops can be triggered by just
plugging a USB device in.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1104,7 +1104,8 @@ skip_normal_probe:
 	}
 
 
-	if (data_interface->cur_altsetting->desc.bNumEndpoints < 2)
+	if (data_interface->cur_altsetting->desc.bNumEndpoints < 2 ||
+	    control_interface->cur_altsetting->desc.bNumEndpoints == 0)
 		return -EINVAL;
 
 	epctrl = &control_interface->cur_altsetting->endpoint[0].desc;


