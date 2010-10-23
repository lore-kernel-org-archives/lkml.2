Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab0JWSoU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 14:44:20 -0400
Received: from mxout5.netvision.net.il ([194.90.9.29]:62119 "EHLO
	mxout5.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116Ab0JWSoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 14:44:16 -0400
Content-transfer-encoding: 7BIT
From: Alon Ziv <alon+git@nolaviz.org>
To: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Alon Ziv <alon+git@nolaviz.org>
Subject: [PATCH v2 1/2] Export usb_serial_generic_write_room for use in modules
Date: Sat, 23 Oct 2010 20:43:28 +0200
Message-id: <1287859409-13810-2-git-send-email-alon-git@nolaviz.org>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1287859409-13810-1-git-send-email-alon-git@nolaviz.org>
References: <1287859409-13810-1-git-send-email-alon-git@nolaviz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any module using usb_serial_generic_write (which is already exported)
had better use usb_serial_generic_write_room as well, or be prepared
for failures.

Signed-off-by: Alon Ziv <alon-git@nolaviz.org>
---
 drivers/usb/serial/generic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index e6833e2..c663369 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -288,6 +288,7 @@ int usb_serial_generic_write_room(struct tty_struct *tty)
 	dbg("%s - returns %d", __func__, room);
 	return room;
 }
+EXPORT_SYMBOL_GPL(usb_serial_generic_write_room);
 
 int usb_serial_generic_chars_in_buffer(struct tty_struct *tty)
 {
-- 
1.7.0.4

