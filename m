Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab1KRNv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:51:56 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:61499 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757928Ab1KRNvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:51:54 -0500
Date: Fri, 18 Nov 2011 14:51:43 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: giancarlo.asnaghi@st.com, balbi@ti.com,
        broonie@opensource.wolfsonmicro.com
Subject: [PATCH V2 2/2] usb: dwc3: use debugfs_print_regs32()
Message-ID: <20111118135143.GA1101@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <20111118002049.GA24806@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This a use example of the regs32 utilities in debugfs, although
this fuse use ":" as separator between name and value, and debugs
uses "=" (as it looked to me a more common practice).

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/dwc3/debugfs.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
index da1ad77..d9e7a26 100644
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -51,18 +51,13 @@
 #include "gadget.h"
 #include "io.h"
 
-struct dwc3_register {
-	const char	*name;
-	u32		offset;
-};
-
 #define dump_register(nm)				\
 {							\
 	.name	= __stringify(nm),			\
 	.offset	= DWC3_ ##nm,				\
 }
 
-static const struct dwc3_register dwc3_regs[] = {
+static const struct debugfs_reg32 dwc3_regs[] = {
 	dump_register(GSBUSCFG0),
 	dump_register(GSBUSCFG1),
 	dump_register(GTXTHRCFG),
@@ -385,12 +380,8 @@ static int dwc3_regdump_show(struct seq_file *s, void *unused)
 	int			i;
 
 	seq_printf(s, "DesignWare USB3 Core Register Dump\n");
-
-	for (i = 0; i < ARRAY_SIZE(dwc3_regs); i++) {
-		seq_printf(s, "%-20s :    %08x\n", dwc3_regs[i].name,
-				dwc3_readl(dwc->regs, dwc3_regs[i].offset));
-	}
-
+	debugfs_print_regs32(s, dwc3_regs, ARRAY_SIZE(dwc3_regs),
+			     dwc->regs, "");
 	return 0;
 }
 
-- 
1.6.0.2
