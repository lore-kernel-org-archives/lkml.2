Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab0GLOtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 10:49:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51172 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab0GLOtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 10:49:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QFso2OhjYGfqLpFAO1O12U0Obku7G7gGY0oB2Pq20Q8pScNWMlX/qiVxhPmyddjpE+
         i84zqg6qob3imPFXM93aJdk+bP+sy6sMIIdqDg8tleIvjs1IqMc2lLlB3CZjAG9xpZWI
         SM215mrLRUVBFjxAzyzmxwaLI1rzCsuMjR+ew=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        "Brian G. Merrell" <bgmerrell@novell.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: usbip: fix memory leak
Date: Mon, 12 Jul 2010 18:48:46 +0400
Message-Id: <1278946126-30353-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sdev should be freed if stub_add_files() failed.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/usbip/stub_dev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 3f95605..1f40851 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -438,6 +438,8 @@ static int stub_probe(struct usb_interface *interface,
 	if (err) {
 		dev_err(&interface->dev, "create sysfs files for %s\n",
 			udev_busid);
+		usb_set_intfdata(interface, 0);
+		stub_device_free(sdev);
 		return err;
 	}
 
-- 
1.7.0.4

