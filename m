Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968Ab1C3VIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:33607 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271Ab1C3VIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447887"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: kees.cook@canonical.com, gregkh@suse.de, bphilips@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [170/275] usb: iowarrior: don't trust report_size for buffer size
Message-Id: <20110330210652.B37953E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>


---
 drivers/usb/misc/iowarrior.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/usb/misc/iowarrior.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/misc/iowarrior.c	2011-03-29 22:50:56.322817258 -0700
+++ linux-2.6.35.y/drivers/usb/misc/iowarrior.c	2011-03-29 23:03:01.783254541 -0700
@@ -373,7 +373,7 @@
 	case USB_DEVICE_ID_CODEMERCS_IOWPV2:
 	case USB_DEVICE_ID_CODEMERCS_IOW40:
 		/* IOW24 and IOW40 use a synchronous call */
-		buf = kmalloc(8, GFP_KERNEL);	/* 8 bytes are enough for both products */
+		buf = kmalloc(count, GFP_KERNEL);
 		if (!buf) {
 			retval = -ENOMEM;
 			goto exit;
