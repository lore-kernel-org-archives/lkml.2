Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1DSUn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:43:56 -0400
Received: from kroah.org ([198.145.64.141]:58999 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab1DSUmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:42:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:41:19 2011
Message-Id: <20110419204119.285492847@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:31:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Torokhov <dtor@vmware.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [24/28] USB: xhci - fix unsafe macro definitions
In-Reply-To: <20110419204122.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Torokhov <dtor@vmware.com>

commit 5a6c2f3ff039154872ce597952f8b8900ea0d732 upstream.

Macro arguments used in expressions need to be enclosed in parenthesis
to avoid unpleasant surprises.

This should be queued for kernels back to 2.6.31

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/xhci.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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


