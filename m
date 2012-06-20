Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab2FTMiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:38:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59129 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2FTMiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:38:19 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: lpc32xx_udc: fix build error with debugfs enabled
Date: Wed, 20 Jun 2012 09:37:57 -0300
Message-Id: <1340195877-10122-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_USB_GADGET_DEBUG_FILES is enabled, lpc32xx_udc breaks
compilation because of a missing include file.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 drivers/usb/gadget/lpc32xx_udc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32xx_udc.c
index d227d93..355bd66 100644
--- a/drivers/usb/gadget/lpc32xx_udc.c
+++ b/drivers/usb/gadget/lpc32xx_udc.c
@@ -61,6 +61,7 @@
 #include <mach/irqs.h>
 #include <mach/board.h>
 #ifdef CONFIG_USB_GADGET_DEBUG_FILES
+#include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #endif
 
-- 
1.7.10

