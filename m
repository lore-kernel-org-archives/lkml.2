Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1JQBUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:20:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42981 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab1JQBUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:20:46 -0400
From: chris@cnpbagwell.com
To: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        pinglinux@gmail.com
Cc: Chris Bagwell <chris@cnpbagwell.com>
Subject: [PATCH 2/6] Input: wacom - remove unused bamboo HID parsing
Date: Sun, 16 Oct 2011 20:20:26 -0500
Message-Id: <1318814430-30316-3-git-send-email-chris@cnpbagwell.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318814430-30316-1-git-send-email-chris@cnpbagwell.com>
References: <1318814430-30316-1-git-send-email-chris@cnpbagwell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Bagwell <chris@cnpbagwell.com>

Bamboo's do not declared a Digitizer-Stylus so the if() was
never executed.  wacom_features already contains correct stylus
packet length.

Signed-off-by: Chris Bagwell <chris@cnpbagwell.com>
---
 drivers/input/tablet/wacom_sys.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 4f35473..620f0c3 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -245,8 +245,6 @@ static int wacom_parse_hid(struct usb_interface *intf, struct hid_descriptor *hi
 						/* penabled only accepts exact bytes of data */
 						if (features->type == TABLETPC2FG)
 							features->pktlen = WACOM_PKGLEN_GRAPHIRE;
-						if (features->type == BAMBOO_PT)
-							features->pktlen = WACOM_PKGLEN_BBFUN;
 						features->device_type = BTN_TOOL_PEN;
 						features->x_max =
 							get_unaligned_le16(&report[i + 3]);
@@ -295,8 +293,6 @@ static int wacom_parse_hid(struct usb_interface *intf, struct hid_descriptor *hi
 						/* penabled only accepts exact bytes of data */
 						if (features->type == TABLETPC2FG)
 							features->pktlen = WACOM_PKGLEN_GRAPHIRE;
-						if (features->type == BAMBOO_PT)
-							features->pktlen = WACOM_PKGLEN_BBFUN;
 						features->device_type = BTN_TOOL_PEN;
 						features->y_max =
 							get_unaligned_le16(&report[i + 3]);
-- 
1.7.6.4

