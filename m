Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2L1T1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:27:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55633 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932421Ab2L1TTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:41 -0500
Message-Id: <20121228190338.294384351@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tatyana Brokhman <tlinder@codeaurora.org>, Felipe Balbi <balbi@ti.com>
Subject: [ 040/173] usb: gadget: network: fix bind() error path
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit e79cc615a9bb44da72c499ccfa2c9c4bbea3aa84 upstream.

I think this is wrong since 72c973dd ("usb: gadget: add
usb_endpoint_descriptor to struct usb_ep"). If we fail to allocate an ep
or bail out early we shouldn't check for the descriptor which is
assigned at ep_enable() time.

Cc: Tatyana Brokhman <tlinder@codeaurora.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/f_ecm.c    |    4 ++--
 drivers/usb/gadget/f_eem.c    |    5 ++---
 drivers/usb/gadget/f_ncm.c    |    4 ++--
 drivers/usb/gadget/f_rndis.c  |    4 ++--
 drivers/usb/gadget/f_subset.c |    4 ++--
 5 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/gadget/f_ecm.c b/drivers/usb/gadget/f_ecm.c
index 7892427..a158740 100644
--- a/drivers/usb/gadget/f_ecm.c
+++ b/drivers/usb/gadget/f_ecm.c
@@ -809,9 +809,9 @@ fail:
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
diff --git a/drivers/usb/gadget/f_eem.c b/drivers/usb/gadget/f_eem.c
index 1a7b2dd..a9cf2052 100644
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
diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
index 4f09500..424fc3d 100644
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
diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
index 61f4b13..7c27626 100644
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
diff --git a/drivers/usb/gadget/f_subset.c b/drivers/usb/gadget/f_subset.c
index 4060c0b..deb437c 100644
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


