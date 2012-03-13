Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab2CMA67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:58:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:47717 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617Ab2CMAWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:31 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dmitry Torokhov <dtor@vmware.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 076/196] USB: xhci - fix unsafe macro definitions
Date: Mon, 12 Mar 2012 20:19:49 -0400
Message-Id: <1331598109-31424-31-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@vmware.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5a6c2f3ff039154872ce597952f8b8900ea0d732 upstream.

Macro arguments used in expressions need to be enclosed in parenthesis
to avoid unpleasant surprises.

This should be queued for kernels back to 2.6.31

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/xhci.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index ea389e9..a51358b 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -232,7 +232,7 @@ struct xhci_op_regs {
  * notification type that matches a bit set in this bit field.
  */
 #define	DEV_NOTE_MASK		(0xffff)
-#define ENABLE_DEV_NOTE(x)	(1 << x)
+#define ENABLE_DEV_NOTE(x)	(1 << (x))
 /* Most of the device notification types should only be used for debug.
  * SW does need to pay attention to function wake notifications.
  */
@@ -579,11 +579,11 @@ struct xhci_ep_ctx {
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
 
 /* ep_info2 bitmasks */
-- 
1.7.9.3

