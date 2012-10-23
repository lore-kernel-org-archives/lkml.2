Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab2JWT6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:58:49 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61542 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab2JWT6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:58:46 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 05/23] pwc: Replace memcpy with struct assignment
Date: Tue, 23 Oct 2012 16:57:08 -0300
Message-Id: <1351022246-8201-5-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kind of memcpy() is error-prone. Its replacement with a struct
assignment is prefered because it's type-safe and much easier to read.

Found by coccinelle. Hand patched and reviewed.
Tested by compilation only.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier struct_name;
struct struct_name to;
struct struct_name from;
expression E;
@@
-memcpy(&(to), &(from), E);
+to = from;
// </smpl>

Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/pwc/pwc-if.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 42e36ba..cc5c7d8 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -1003,7 +1003,7 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 	vb2_queue_init(&pdev->vb_queue);
 
 	/* Init video_device structure */
-	memcpy(&pdev->vdev, &pwc_template, sizeof(pwc_template));
+	pdev->vdev = pwc_template;
 	strcpy(pdev->vdev.name, name);
 	pdev->vdev.queue = &pdev->vb_queue;
 	pdev->vdev.queue->lock = &pdev->vb_queue_lock;
-- 
1.7.4.4

