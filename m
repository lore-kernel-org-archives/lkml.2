Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab0KCSCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:02:51 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57372 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0KCSCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:02:49 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] usb: gadget: goku_udc: add registered flag bit
Date: Wed,  3 Nov 2010 18:02:38 +0000
Message-Id: <1288807358-11813-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit below cleaned up error handling, in part by introducing a
registered flag bit.  This however was not added to the device
structure leding to build failures:

  commit 319feaabb6c7ccd90da6e3207563c265da7d21ae
  Author: Dan Carpenter <error27@gmail.com>
  Date:   Tue Oct 5 18:55:34 2010 +0200

    usb: gadget: goku_udc: Fix error path

Add the missing registered flag bit.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/usb/gadget/goku_udc.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/goku_udc.h b/drivers/usb/gadget/goku_udc.h
index 566cb23..e7e0c69 100644
--- a/drivers/usb/gadget/goku_udc.h
+++ b/drivers/usb/gadget/goku_udc.h
@@ -251,7 +251,8 @@ struct goku_udc {
 					got_region:1,
 					req_config:1,
 					configured:1,
-					enabled:1;
+					enabled:1,
+					registered:1;
 
 	/* pci state used to access those endpoints */
 	struct pci_dev			*pdev;
-- 
1.7.1

