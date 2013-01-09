Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480Ab3AIV3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:29:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:42511 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933440Ab3AIUjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tatyana Brokhman <tlinder@codeaurora.org>, Felipe Balbi <balbi@ti.com>
Subject: [ 33/80] usb: gadget: network: fix bind() error path
Date: Wed,  9 Jan 2013 12:35:25 -0800
Message-Id: <20130109201504.637089292@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit e79cc615a9bb44da72c499ccfa2c9c4bbea3aa84 upstream.

I think this is wrong since 72c973dd ("usb: gadget: add
usb_endpoint_descriptor to struct usb_ep"). If we fail to allocate an ep
or bail out early we shouldn't check for the descriptor which is
assigned at ep_enable() time.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tatyana Brokhman <tlinder@codeaurora.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/f_ecm.c    |    4 ++--
 drivers/usb/gadget/f_eem.c    |    5 ++---
 drivers/usb/gadget/f_ncm.c    |    4 ++--
 drivers/usb/gadget/f_rndis.c  |    4 ++--
 drivers/usb/gadget/f_subset.c |    4 ++--
 5 files changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/usb/gadget/f_ecm.c
+++ b/drivers/usb/gadget/f_ecm.c
@@ -808,9 +808,9 @@ fail:
 	/* we might as well release our claims on endpoints */
 	if (ecm->notify)
 		ecm->notify->driver_data = NULL;
-	if (ecm->port.out_ep->desc)
+	if (ecm->port.out_ep)
 		ecm->port.out_ep->driver_data = NULL;
-	if (ecm->port.in_ep->desc)
+	if (ecm->port.in_ep)
 		ecm->port.in_ep->driver_data = NULL;
 
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
--- a/drivers/usb/gadget/f_eem.c
+++ b/drivers/usb/gadget/f_eem.c
@@ -319,10 +319,9 @@ fail:
 	if (f->hs_descriptors)
 		usb_free_descriptors(f->hs_descriptors);
 
-	/* we might as well release our claims on endpoints */
-	if (eem->port.out_ep->desc)
+	if (eem->port.out_ep)
 		eem->port.out_ep->driver_data = NULL;
-	if (eem->port.in_ep->desc)
+	if (eem->port.in_ep)
 		eem->port.in_ep->driver_data = NULL;
 
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
--- a/drivers/usb/gadget/f_ncm.c
+++ b/drivers/usb/gadget/f_ncm.c
@@ -1259,9 +1259,9 @@ fail:
 	/* we might as well release our claims on endpoints */
 	if (ncm->notify)
 		ncm->notify->driver_data = NULL;
-	if (ncm->port.out_ep->desc)
+	if (ncm->port.out_ep)
 		ncm->port.out_ep->driver_data = NULL;
-	if (ncm->port.in_ep->desc)
+	if (ncm->port.in_ep)
 		ncm->port.in_ep->driver_data = NULL;
 
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -803,9 +803,9 @@ fail:
 	/* we might as well release our claims on endpoints */
 	if (rndis->notify)
 		rndis->notify->driver_data = NULL;
-	if (rndis->port.out_ep->desc)
+	if (rndis->port.out_ep)
 		rndis->port.out_ep->driver_data = NULL;
-	if (rndis->port.in_ep->desc)
+	if (rndis->port.in_ep)
 		rndis->port.in_ep->driver_data = NULL;
 
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);
--- a/drivers/usb/gadget/f_subset.c
+++ b/drivers/usb/gadget/f_subset.c
@@ -370,9 +370,9 @@ fail:
 		usb_free_descriptors(f->hs_descriptors);
 
 	/* we might as well release our claims on endpoints */
-	if (geth->port.out_ep->desc)
+	if (geth->port.out_ep)
 		geth->port.out_ep->driver_data = NULL;
-	if (geth->port.in_ep->desc)
+	if (geth->port.in_ep)
 		geth->port.in_ep->driver_data = NULL;
 
 	ERROR(cdev, "%s: can't bind, err %d\n", f->name, status);


