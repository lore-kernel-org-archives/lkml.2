Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787Ab1LERdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:33:05 -0500
Received: from www17.your-server.de ([213.133.104.17]:50062 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab1LERa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:30:58 -0500
Subject: [PATCH] usb: gadget: storage: Use kcalloc instead of kzalloc to
 allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.336.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
--- a/drivers/usb/gadget/f_fs.c 2011-11-13 11:07:51.550550667 +0100
+++ b/drivers/usb/gadget/f_fs.c 2011-11-28 20:05:17.011277814 +0100
@@ -1408,7 +1408,7 @@ static int ffs_epfiles_create(struct ffs
 	ENTER();
 
 	count = ffs->eps_count;
-	epfiles = kzalloc(count * sizeof *epfiles, GFP_KERNEL);
+	epfiles = kcalloc(count, sizeof(*epfiles), GFP_KERNEL);
 	if (!epfiles)
 		return -ENOMEM;
 
diff -u -p a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
--- a/drivers/usb/gadget/f_mass_storage.c 2011-11-28 19:36:48.006781560 +0100
+++ b/drivers/usb/gadget/f_mass_storage.c 2011-11-28 20:05:29.388010153 +0100
@@ -2763,7 +2763,7 @@ static struct fsg_common *fsg_common_ini
 	 * Create the LUNs, open their backing files, and register the
 	 * LUN devices in sysfs.
 	 */
-	curlun = kzalloc(nluns * sizeof *curlun, GFP_KERNEL);
+	curlun = kcalloc(nluns, sizeof(*curlun), GFP_KERNEL);
 	if (unlikely(!curlun)) {
 		rc = -ENOMEM;
 		goto error_release;
