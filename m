Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab2KBRLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:11:37 -0400
Received: from mail.kernel.org ([198.145.19.201]:33422 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763006Ab2KBRHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fengguang Wu <fengguang.wu@intel.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 16/24] USB: iuu_phoenix: fix backported patches
Date: Fri,  2 Nov 2012 10:07:04 -0700
Message-Id: <20121102170248.584117825@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170247.406319110@linuxfoundation.org>
References: <20121102170247.406319110@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

Fix two memory leaks involving dbgbuf that were introduced in port-probe
error paths when backporting the following port-data fixes from v3.7
(which doesn't have dbgbuf):

0978c94 USB: iuu_phoenix: fix sysfs-attribute creation
5363655 USB: iuu_phoenix: fix port-data memory leak

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/iuu_phoenix.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -105,7 +105,7 @@ static int iuu_port_probe(struct usb_ser
 	}
 
 	priv->dbgbuf = kzalloc(256, GFP_KERNEL);
-	if (!priv->writebuf) {
+	if (!priv->dbgbuf) {
 		kfree(priv->writebuf);
 		kfree(priv->buf);
 		kfree(priv);
@@ -120,6 +120,7 @@ static int iuu_port_probe(struct usb_ser
 
 	ret = iuu_create_sysfs_attrs(port);
 	if (ret) {
+		kfree(priv->dbgbuf);
 		kfree(priv->writebuf);
 		kfree(priv->buf);
 		kfree(priv);


