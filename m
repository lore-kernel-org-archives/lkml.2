Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab0KSV6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:58:47 -0500
Received: from kroah.org ([198.145.64.141]:45141 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932659Ab0KSV6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:44 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:42 2010
Message-Id: <20101119215642.137282088@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Linus Walleij <linus.walleij@stericsson.com>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>
Subject: [41/82] USB: Change acm_iad_descriptor bFunctionProtocol to USB_CDC_ACM_PROTO_AT_V25TER
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Praveena Nadahally <praveen.nadahally@stericsson.com>

commit 5c8db070b4480c43394680d9dfd2ddb06b97d2ae upstream.

The protocol code is set 00 in IAD and it's set to 01 in ACM control
interface descriptor in f_acm.c file. Due to this, windows is unable to
install the modem(ACM) driver based on class-subclass-protocol matching.

This patch corrects the protocol code in ACM IAD to the same as in
acm_control_interface_desc protocol code.

Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Praveena Nadahally <praveen.nadahally@stericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/f_acm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -111,7 +111,7 @@ acm_iad_descriptor = {
 	.bInterfaceCount = 	2,	// control + data
 	.bFunctionClass =	USB_CLASS_COMM,
 	.bFunctionSubClass =	USB_CDC_SUBCLASS_ACM,
-	.bFunctionProtocol =	USB_CDC_PROTO_NONE,
+	.bFunctionProtocol =	USB_CDC_ACM_PROTO_AT_V25TER,
 	/* .iFunction =		DYNAMIC */
 };
 


