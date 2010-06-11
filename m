Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086Ab0FKCUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 22:20:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1040 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733Ab0FKCUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 22:20:45 -0400
Subject: [PATCH] drivers/usb/gadget/langwell_udc.c: printk needs a
 (unsigned long long) cast for a dma_t
From: Joe Perches <joe@perches.com>
To: Xiaochen Shen <xiaochen.shen@intel.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 19:20:43 -0700
Message-ID: <1276222843.1556.438.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index a391351..d41b69c 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -842,9 +841,9 @@ static int langwell_ep_queue(struct usb_ep *_ep, struct usb_request *_req,
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


