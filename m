Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab1HWTxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:53:04 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:50198 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756029Ab1HWTwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:52:49 -0400
Date: Tue, 23 Aug 2011 12:52:47 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: balbi@ti.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        gregkh@suse.de, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org
Subject: [PATCH -next v2] usb: fix dwc3 build when USB_GADGET_DWC3 is not
 enabled
Message-Id: <20110823125247.fbbf9636.rdunlap@xenotime.net>
In-Reply-To: <20110823185235.GA11299@legolas.emea.dhcp.ti.com>
References: <20110823160432.d24f8cad00951286bc18461e@canb.auug.org.au>
	<20110823110702.f5ea377c.rdunlap@xenotime.net>
	<20110823185235.GA11299@legolas.emea.dhcp.ti.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build error when CONFIG_USB_GADGET_DWC3 is not enabled:

ERROR: "dwc3_send_gadget_ep_cmd" [drivers/usb/dwc3/dwc3.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/usb/dwc3/gadget.h |    5 +++++
 1 file changed, 5 insertions(+)

--- linux-next-20110823.orig/drivers/usb/dwc3/gadget.h
+++ linux-next-20110823/drivers/usb/dwc3/gadget.h
@@ -202,6 +202,11 @@ void dwc3_gadget_exit(struct dwc3 *dwc);
 #else
 static inline int dwc3_gadget_init(struct dwc3 *dwc) { return 0; }
 static inline void dwc3_gadget_exit(struct dwc3 *dwc) { }
+static inline int dwc3_send_gadget_ep_cmd(struct dwc3 *dwc, unsigned ep,
+		unsigned cmd, struct dwc3_gadget_ep_cmd_params *params)
+{
+	return 0;
+}
 #endif
 
 void dwc3_gadget_giveback(struct dwc3_ep *dep, struct dwc3_request *req,
