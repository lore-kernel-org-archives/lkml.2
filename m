Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab0LHBWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:22:35 -0500
Received: from kroah.org ([198.145.64.141]:33561 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932588Ab0LHBC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:56 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:41 2010
Message-Id: <20101208005741.583362527@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segooon@gmail.com>
Subject: [201/289] usb: misc: sisusbvga: fix information leak to userland
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segooon@gmail.com>

commit 5dc92cf1d0b4b0debbd2e333b83f9746c103533d upstream.

Structure sisusb_info is copied to userland with "sisusb_reserved" field
uninitialized.  It leads to leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/misc/sisusbvga/sisusb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3008,6 +3008,7 @@ sisusb_ioctl(struct file *file, unsigned
 #else
 			x.sisusb_conactive  = 0;
 #endif
+			memset(x.sisusb_reserved, 0, sizeof(x.sisusb_reserved));
 
 			if (copy_to_user((void __user *)arg, &x, sizeof(x)))
 				retval = -EFAULT;


