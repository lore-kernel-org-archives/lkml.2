Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613Ab1DNR4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:56:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:38337 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933258Ab1DNRqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Vasiliy Kulikov <segooon@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 075/209] usb: misc: sisusbvga: fix information leak to userland
Date: Thu, 14 Apr 2011 13:41:45 -0400
Message-Id: <1302803039-9400-76-git-send-email-paul.gortmaker@windriver.com>
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

commit 5dc92cf1d0b4b0debbd2e333b83f9746c103533d upstream.

Structure sisusb_info is copied to userland with "sisusb_reserved" field
uninitialized.  It leads to leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/misc/sisusbvga/sisusb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index cf13923..ba0a0bb 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3018,6 +3018,7 @@ sisusb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 #else
 			x.sisusb_conactive  = 0;
 #endif
+			memset(x.sisusb_reserved, 0, sizeof(x.sisusb_reserved));
 
 			if (copy_to_user((void __user *)arg, &x, sizeof(x)))
 				retval = -EFAULT;
-- 
1.7.4.4

