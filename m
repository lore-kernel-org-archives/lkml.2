Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1HWSHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:07:07 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:43455 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754659Ab1HWSHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:07:04 -0400
Date: Tue, 23 Aug 2011 11:07:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH -next] usb: fix dwc3 build when USB_GADGET_DWC3 is not
 enabled
Message-Id: <20110823110702.f5ea377c.rdunlap@xenotime.net>
In-Reply-To: <20110823160432.d24f8cad00951286bc18461e@canb.auug.org.au>
References: <20110823160432.d24f8cad00951286bc18461e@canb.auug.org.au>
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
 drivers/usb/dwc3/debugfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20110823.orig/drivers/usb/dwc3/debugfs.c
+++ linux-next-20110823/drivers/usb/dwc3/debugfs.c
@@ -437,7 +437,9 @@ static int dwc3_testmode_open(struct ino
 	struct dwc3_gadget_ep_cmd_params par0;
 	struct dwc3_gadget_ep_cmd_params par1;
 	struct dwc3_trb         trb;
+#ifdef CONFIG_USB_GADGET_DWC3
 	int ret;
+#endif
 	u8 *buf0;
 	u8 *buf1;
 
@@ -478,8 +480,10 @@ static int dwc3_testmode_open(struct ino
 
 	dwc3_send_testmode_cmd(dwc, 1);
 
+#ifdef CONFIG_USB_GADGET_DWC3
 	ret = dwc3_send_gadget_ep_cmd(dwc, 0, DWC3_DEPCMD_STARTTRANSFER, &par0);
 	ret = dwc3_send_gadget_ep_cmd(dwc, 1, DWC3_DEPCMD_STARTTRANSFER, &par1);
+#endif
 
 	dwc3_send_testmode_cmd(dwc, 0);
 	return -EBUSY;
