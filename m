Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab1DZVYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:24:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:1301 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179Ab1DZVOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="914748808"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: dtor@vmware.com, sarah.a.sharp@linux.intel.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [76/106] USB: xhci - fix unsafe macro definitions
Message-Id: <20110426211357.BAA993E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dmitry Torokhov <dtor@vmware.com>

commit 5a6c2f3ff039154872ce597952f8b8900ea0d732 upstream.

Macro arguments used in expressions need to be enclosed in parenthesis
to avoid unpleasant surprises.

This should be queued for kernels back to 2.6.31

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/host/xhci.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/drivers/usb/host/xhci.h
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/host/xhci.h
+++ linux-2.6.35.y/drivers/usb/host/xhci.h
@@ -232,7 +232,7 @@ struct xhci_op_regs {
  * notification type that matches a bit set in this bit field.
  */
 #define	DEV_NOTE_MASK		(0xffff)
-#define ENABLE_DEV_NOTE(x)	(1 << x)
+#define ENABLE_DEV_NOTE(x)	(1 << (x))
 /* Most of the device notification types should only be used for debug.
  * SW does need to pay attention to function wake notifications.
  */
@@ -598,11 +598,11 @@ struct xhci_ep_ctx {
 #define EP_STATE_STOPPED	3
 #define EP_STATE_ERROR		4
 /* Mult - Max number of burtst within an interval, in EP companion desc. */
-#define EP_MULT(p)		((p & 0x3) << 8)
+#define EP_MULT(p)		(((p) & 0x3) << 8)
 /* bits 10:14 are Max Primary Streams */
 /* bit 15 is Linear Stream Array */
 /* Interval - period between requests to an endpoint - 125u increments. */
-#define EP_INTERVAL(p)		((p & 0xff) << 16)
+#define EP_INTERVAL(p)		(((p) & 0xff) << 16)
 #define EP_INTERVAL_TO_UFRAMES(p)		(1 << (((p) >> 16) & 0xff))
 #define EP_MAXPSTREAMS_MASK	(0x1f << 10)
 #define EP_MAXPSTREAMS(p)	(((p) << 10) & EP_MAXPSTREAMS_MASK)
