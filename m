Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032745Ab2CPLV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 07:21:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44881 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab2CPLVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 07:21:23 -0400
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: f_mass_storage: remove deprecated fsg_add()
Date: Fri, 16 Mar 2012 12:21:15 +0100
Message-Id: <1ad5f25435fc5d2cd094ae1c68d7831b8b2737ca.1331896818.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

There are no in-tree fsg_add() users and it has been deprecated
since 2.6.35 [1dc90985d1: fsg_add() renamed to fsg_bind_config()] so
out-of-tree users had more then enough time to convert.  Removing.
---
 drivers/usb/gadget/f_mass_storage.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index a371e96..47383f4 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -3110,13 +3110,6 @@ static int fsg_bind_config(struct usb_composite_dev *cdev,
 	return rc;
 }
 
-static inline int __deprecated __maybe_unused
-fsg_add(struct usb_composite_dev *cdev, struct usb_configuration *c,
-	struct fsg_common *common)
-{
-	return fsg_bind_config(cdev, c, common);
-}
-
 
 /************************* Module parameters *************************/
 
-- 
1.7.9.2

