Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab0JCEzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 00:55:46 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:40575 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab0JCEzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 00:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ttTpkp9nEEoQAEdIIH341h6sYe1Eqx1LdYk/ro4oSWlX3hUWDF6PHneD+cBp9CWjH0
         qHV//F3TTl2x6WNYoAYqtBi6pp8iS1djGu+MXRdozjkYGLr6SRgC12UYXem2G43HQDdO
         VhDmpKWAAcyeHbADTaCLcrBJaiLDvmWuelJmg=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Christoph Hellwig <hch@lst.de>, Alan Stern <stern@rowland.harvard.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] usb: gadget: file_storage: Fix error path
Date: Sun,  3 Oct 2010 10:25:17 +0530
Message-Id: <1286081717-2757-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call put_device() when device_register() fails.

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/usb/gadget/file_storage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index a857b7a..2c94318 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3413,6 +3413,7 @@ static int __ref fsg_bind(struct usb_gadget *gadget)
 
 		if ((rc = device_register(&curlun->dev)) != 0) {
 			INFO(fsg, "failed to register LUN%d: %d\n", i, rc);
+			put_device(&curlun->dev);
 			goto out;
 		}
 		if ((rc = device_create_file(&curlun->dev,
-- 
1.7.2.3

