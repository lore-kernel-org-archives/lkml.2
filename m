Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933378Ab0FRN7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:59:07 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44249 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab0FRN7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:59:05 -0400
Date: Fri, 18 Jun 2010 15:59:43 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: gadget: f_mass_storage: dead code removed
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
Message-id: <51bd2ee9463ebc8665480baac702645c4947b37a.1276868197.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ep0req_name was never used in f_mass_storage hence it may
be safely removed from the code.  It was a leftover from File
Storage Gadget which used it for debug messages.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
---
 drivers/usb/gadget/f_mass_storage.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 7d05a0b..44dbb29 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -333,7 +333,6 @@ struct fsg_common {
 	struct usb_ep		*ep0;		/* Copy of gadget->ep0 */
 	struct usb_request	*ep0req;	/* Copy of cdev->req */
 	unsigned int		ep0_req_tag;
-	const char		*ep0req_name;
 
 	struct fsg_buffhd	*next_buffhd_to_fill;
 	struct fsg_buffhd	*next_buffhd_to_drain;
@@ -624,8 +623,6 @@ static int fsg_setup(struct usb_function *f,
 
 		/* Respond with data/status */
 		req->length = min((u16)1, w_length);
-		fsg->common->ep0req_name =
-			ctrl->bRequestType & USB_DIR_IN ? "ep0-in" : "ep0-out";
 		return ep0_queue(fsg->common);
 	}
 
-- 
1.7.1

