Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964918Ab2C3XE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:04:27 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:42730 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934819Ab2C3XET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 19:04:19 -0400
Message-Id: <201203302304.q2UN4IJr011509@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 19:03:04 -0400
Subject: [PATCH] tile-srom.c driver: minor code cleanup
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 23:04:19.0004 (UTC) FILETIME=[6FC577C0:01CD0EC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't fix any bugs, but it makes the code a little cleaner.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 drivers/char/tile-srom.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tile-srom.c b/drivers/char/tile-srom.c
index 4dc0194..3b22a60 100644
--- a/drivers/char/tile-srom.c
+++ b/drivers/char/tile-srom.c
@@ -194,17 +194,17 @@ static ssize_t srom_read(struct file *filp, char __user *buf,
 
 		hv_retval = _srom_read(srom->hv_devhdl, kernbuf,
 				       *f_pos, bytes_this_pass);
-		if (hv_retval > 0) {
-			if (copy_to_user(buf, kernbuf, hv_retval) != 0) {
-				retval = -EFAULT;
-				break;
-			}
-		} else if (hv_retval <= 0) {
+		if (hv_retval <= 0) {
 			if (retval == 0)
 				retval = hv_retval;
 			break;
 		}
 
+		if (copy_to_user(buf, kernbuf, hv_retval) != 0) {
+			retval = -EFAULT;
+			break;
+		}
+
 		retval += hv_retval;
 		*f_pos += hv_retval;
 		buf += hv_retval;
-- 
1.6.5.2

