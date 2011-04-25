Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab1DYUYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:24:15 -0400
Received: from 1wt.eu ([62.212.114.60]:33934 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305Ab1DYUYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:12 -0400
Message-Id: <20110425200236.001214783@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Kees Cook <kees.cook@canonical.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Brandon Philips <bphilips@suse.de>
Subject: [PATCH 069/173] usb: iowarrior: dont trust report_size for buffer size
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kees Cook <kees.cook@canonical.com>

commit 3ed780117dbe5acb64280d218f0347f238dafed0 upstream.

If the iowarrior devices in this case statement support more than 8 bytes
per report, it is possible to write past the end of a kernel heap allocation.
This will probably never be possible, but change the allocation to be more
defensive anyway.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Brandon Philips <bphilips@suse.de>


---
 drivers/usb/misc/iowarrior.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -373,7 +373,7 @@ static ssize_t iowarrior_write(struct fi
 	case USB_DEVICE_ID_CODEMERCS_IOWPV2:
 	case USB_DEVICE_ID_CODEMERCS_IOW40:
 		/* IOW24 and IOW40 use a synchronous call */
-		buf = kmalloc(8, GFP_KERNEL);	/* 8 bytes are enough for both products */
+		buf = kmalloc(count, GFP_KERNEL);
 		if (!buf) {
 			retval = -ENOMEM;
 			goto exit;


