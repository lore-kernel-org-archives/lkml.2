Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab1DNR4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:56:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:38349 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab1DNRqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:48 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vasiliy Kulikov <segooon@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 076/209] usb: misc: iowarrior: fix information leak to userland
Date: Thu, 14 Apr 2011 13:41:46 -0400
Message-Id: <1302803039-9400-77-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit eca67aaeebd6e5d22b0d991af1dd0424dc703bfb upstream.

Structure iowarrior_info is copied to userland with padding byted
between "serial" and "revision" fields uninitialized.  It leads to
leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Acked-by: Kees Cook <kees.cook@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/misc/iowarrior.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index d3c8523..7c84321 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -552,6 +552,7 @@ static long iowarrior_ioctl(struct file *file, unsigned int cmd,
 			/* needed for power consumption */
 			struct usb_config_descriptor *cfg_descriptor = &dev->udev->actconfig->desc;
 
+			memset(&info, 0, sizeof(info));
 			/* directly from the descriptor */
 			info.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
 			info.product = dev->product_id;
-- 
1.7.4.4

