Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845Ab1FWSE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:04:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:34798 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000Ab1FWRhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:07 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Kees Cook <kees.cook@canonical.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 147/247] usb: iowarrior: don't trust report_size for buffer size
Date: Thu, 23 Jun 2011 13:33:35 -0400
Message-Id: <1308850515-15242-88-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <kees.cook@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3ed780117dbe5acb64280d218f0347f238dafed0 upstream.

If the iowarrior devices in this case statement support more than 8 bytes
per report, it is possible to write past the end of a kernel heap allocation.
This will probably never be possible, but change the allocation to be more
defensive anyway.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/misc/iowarrior.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 7c84321..f2a4ad5 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -373,7 +373,7 @@ static ssize_t iowarrior_write(struct file *file,
 	case USB_DEVICE_ID_CODEMERCS_IOWPV2:
 	case USB_DEVICE_ID_CODEMERCS_IOW40:
 		/* IOW24 and IOW40 use a synchronous call */
-		buf = kmalloc(8, GFP_KERNEL);	/* 8 bytes are enough for both products */
+		buf = kmalloc(count, GFP_KERNEL);
 		if (!buf) {
 			retval = -ENOMEM;
 			goto exit;
-- 
1.7.4.4

