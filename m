Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab0JKS2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 14:28:34 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38886 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355Ab0JKS2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 14:28:33 -0400
Date: Mon, 11 Oct 2010 11:28:16 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
        Joe Perches <joe@perches.com>,
        =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
        linux-usb@vger.kernel.org
Subject: [PATCH] usb: don't trust report_size for buffer size
Message-ID: <20101011182816.GA15451@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the iowarrior devices in this case statement support more than 8 bytes
per report, it is possible to write past the end of a kernel heap allocation.
This will probably never be possible, but change the allocation to be more
defensive anyway.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 drivers/usb/misc/iowarrior.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index bc88c79..8ed8d05 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -374,7 +374,7 @@ static ssize_t iowarrior_write(struct file *file,
 	case USB_DEVICE_ID_CODEMERCS_IOWPV2:
 	case USB_DEVICE_ID_CODEMERCS_IOW40:
 		/* IOW24 and IOW40 use a synchronous call */
-		buf = kmalloc(8, GFP_KERNEL);	/* 8 bytes are enough for both products */
+		buf = kmalloc(count, GFP_KERNEL);
 		if (!buf) {
 			retval = -ENOMEM;
 			goto exit;
-- 
1.7.1

-- 
Kees Cook
Ubuntu Security Team
