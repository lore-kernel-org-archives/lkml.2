Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab2IIXY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:24:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51395 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756201Ab2IIXQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:52 -0400
Message-Id: <20120909224157.635637419@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:40 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sven Schnelle <svens@stackframe.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 50/95] USB: CDC ACM: Fix NULL pointer dereference
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 56d6bf6..f763ed7 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1104,7 +1104,8 @@ skip_normal_probe:
 	}
 
 
-	if (data_interface->cur_altsetting->desc.bNumEndpoints < 2)
+	if (data_interface->cur_altsetting->desc.bNumEndpoints < 2 ||
+	    control_interface->cur_altsetting->desc.bNumEndpoints == 0)
 		return -EINVAL;
 
 	epctrl = &control_interface->cur_altsetting->endpoint[0].desc;


