Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab0FPVC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 17:02:27 -0400
Received: from kroah.org ([198.145.64.141]:35431 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932638Ab0FPVCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 17:02:25 -0400
Subject: patch usb-gadget-langwell_udc.c-printk-needs-a-unsigned-long-long-cast-for-a-dma_t.patch added to gregkh-2.6 tree
To: joe@perches.com, dbrownell@users.sourceforge.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       xiaochen.shen@intel.com
From: <gregkh@suse.de>
Date: Wed, 16 Jun 2010 14:01:42 -0700
In-Reply-To: <1276222843.1556.438.camel@Joe-Laptop.home>
Message-ID: <12767221022072@site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: USB: gadget: langwell_udc.c: printk needs a (unsigned long long) cast for a dma_t

to my gregkh-2.6 tree.  Its filename is

    usb-gadget-langwell_udc.c-printk-needs-a-unsigned-long-long-cast-for-a-dma_t.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From joe@perches.com  Wed Jun 16 13:30:08 2010
From: Joe Perches <joe@perches.com>
Date: Thu, 10 Jun 2010 19:20:43 -0700
Subject: USB: gadget: langwell_udc.c: printk needs a (unsigned long long) cast for a dma_t
To: Xiaochen Shen <xiaochen.shen@intel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>, Greg Kroah-Hartman <gregkh@suse.de>, linux-usb <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <1276222843.1556.438.camel@Joe-Laptop.home>


Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/langwell_udc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -842,9 +842,9 @@ static int langwell_ep_queue(struct usb_
 		VDBG(dev, "req->mapped = 0\n");
 	}
 
-	DBG(dev, "%s queue req %p, len %u, buf %p, dma 0x%08x\n",
-			_ep->name,
-			_req, _req->length, _req->buf, _req->dma);
+	DBG(dev, "%s queue req %p, len %u, buf %p, dma 0x%08llx\n",
+	    _ep->name,
+	    _req, _req->length, _req->buf, (unsigned long long)_req->dma);
 
 	_req->status = -EINPROGRESS;
 	_req->actual = 0;

