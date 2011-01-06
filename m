Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab1AFIAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:00:49 -0500
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:60493 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855Ab1AFIAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:00:43 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-11.arcor-online.net 07F8635A399
Subject: [PATCH 2/2] HID: roccat: Fix an error message when reading more
 data from bin attributes
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 09:00:41 +0100
Message-ID: <1294300841.5622.59.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using cat or something to read from binary attributes would try to do an
additional read with offset equal to filesize. This resulted in an invalid
attribute error. This is fixed by giving the right answer instead of EINVAL.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-koneplus.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 1608c8d..2df87bb 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -256,6 +256,9 @@ static ssize_t koneplus_sysfs_read(struct file *fp, struct kobject *kobj,
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
 	int retval;
 
+	if (off >= real_size)
+		return 0;
+
 	if (off != 0 || count != real_size)
 		return -EINVAL;
 
-- 
1.7.3.4



