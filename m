Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab0GLWm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:42:56 -0400
Received: from shutemov.name ([188.40.19.243]:59191 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab0GLWmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:42:55 -0400
Date: Tue, 13 Jul 2010 01:42:54 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix building of tusb6010
Message-ID: <20100712224254.GA29115@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      drivers/usb/musb/tusb6010.o
drivers/usb/musb/tusb6010.c:34: error: expected identifier or '(' before 'do'
drivers/usb/musb/tusb6010.c:34: error: expected identifier or '(' before 'while'
drivers/usb/musb/tusb6010.c:39: error: expected identifier or '(' before 'do'
drivers/usb/musb/tusb6010.c:39: error: expected identifier or '(' before 'while'
make[2]: *** [drivers/usb/musb/tusb6010.o] Error 1
make[1]: *** [drivers/usb/musb] Error 2
make: *** [drivers] Error 2

Empty musb_platform_save_context and musb_platform_restore_context
provided by musb_core.h.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 drivers/usb/musb/tusb6010.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 05c077f..3c48e77 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -29,19 +29,6 @@ static void tusb_source_power(struct musb *musb, int is_on);
 #define TUSB_REV_MAJOR(reg_val)		((reg_val >> 4) & 0xf)
 #define TUSB_REV_MINOR(reg_val)		(reg_val & 0xf)
 
-#ifdef CONFIG_PM
-/* REVISIT: These should be only needed if somebody implements off idle */
-void musb_platform_save_context(struct musb *musb,
-			struct musb_context_registers *musb_context)
-{
-}
-
-void musb_platform_restore_context(struct musb *musb,
-			struct musb_context_registers *musb_context)
-{
-}
-#endif
-
 /*
  * Checks the revision. We need to use the DMA register as 3.0 does not
  * have correct versions for TUSB_PRCM_REV or TUSB_INT_CTRL_REV.
-- 
1.7.1.1
