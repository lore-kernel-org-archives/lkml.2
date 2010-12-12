Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0LLXrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36448 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab0LLXrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:35 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: segooon@gmail.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [150/223] usb: misc: sisusbvga: fix information leak to userland
Message-Id: <20101212234733.74C52B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segooon@gmail.com>

commit 5dc92cf1d0b4b0debbd2e333b83f9746c103533d upstream.

Structure sisusb_info is copied to userland with "sisusb_reserved" field
uninitialized.  It leads to leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/misc/sisusbvga/sisusb.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/usb/misc/sisusbvga/sisusb.c
===================================================================
--- linux.orig/drivers/usb/misc/sisusbvga/sisusb.c
+++ linux/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3008,6 +3008,7 @@ sisusb_ioctl(struct file *file, unsigned
 #else
 			x.sisusb_conactive  = 0;
 #endif
+			memset(x.sisusb_reserved, 0, sizeof(x.sisusb_reserved));
 
 			if (copy_to_user((void __user *)arg, &x, sizeof(x)))
 				retval = -EFAULT;
