Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab0J1Pb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:31:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63317 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab0J1Pbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qpJqGboEkSozxjmyvQd0Be94J6VMoZ09LwN+jpwPjWqkUlFqsE8VX3Eg2mc+KxMr6M
         q8d0x9X3sz8AtP63HBti3sfwwt9zaEGo1m5qbvz87RYyw81twQcviPGOG/kXsggkX27Q
         T/I+a2MaQMIlrAQMGh+ItejkIUKMjZnTB9nyE=
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Rahul Ruikar <rahul.ruikar@gmail.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCHv2 2/7] USB: gadget: f_mass_storage: put_device() in error recovery
Date: Thu, 28 Oct 2010 17:31:19 +0200
Message-Id: <e922dfede43c52ea5412fbc5ec96385709600642.1288256118.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <bfcc3341c937589451942f87d944659faf6c9e3c.1288256118.git.mina86@mina86.com>
References: <bfcc3341c937589451942f87d944659faf6c9e3c.1288256118.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rahul Ruikar <rahul.ruikar@gmail.com>

This commit fixes an issue with error recovery after
device_register() fails in Mass Storage Function.  The device
needs to be put to avoid resource leakage.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
[mina86@mina86.com: updated commit message]
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 838286b..c89b992 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2765,6 +2765,7 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 		if (rc) {
 			INFO(common, "failed to register LUN%d: %d\n", i, rc);
 			common->nluns = i;
+			put_device(&curlun->dev);
 			goto error_release;
 		}
 
-- 
1.7.1

