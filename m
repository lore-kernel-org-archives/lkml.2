Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab2JAXQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:16:26 -0400
Received: from 1wt.eu ([62.212.114.60]:35481 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933059Ab2JAXCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:02:00 -0400
Message-Id: <20121001225203.293216816@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sven Schnelle <svens@stackframe.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 134/180] USB: CDC ACM: Fix NULL pointer dereference
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/class/cdc-acm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 653f853..8ad9dfb 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1120,7 +1120,8 @@ skip_normal_probe:
 	}
 
 
-	if (data_interface->cur_altsetting->desc.bNumEndpoints < 2)
+	if (data_interface->cur_altsetting->desc.bNumEndpoints < 2 ||
+	    control_interface->cur_altsetting->desc.bNumEndpoints == 0)
 		return -EINVAL;
 
 	epctrl = &control_interface->cur_altsetting->endpoint[0].desc;
-- 
1.7.2.1.45.g54fbc



