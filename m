Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab0G3R6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:58:21 -0400
Received: from kroah.org ([198.145.64.141]:58955 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760074Ab0G3R46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:58 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:46 2010
Message-Id: <20100730175146.889355233@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felipe Balbi <felipe.balbi@nokia.com>
Subject: [142/205] USB: musb: tusb6010: fix compile error with n8x0_defconfig
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felipe Balbi <felipe.balbi@nokia.com>

commit 2b795ea00c2bbb077a1199a4d729c8ac03a6bded upstream.

Drop the unnecessary empty stubs in tusb6010.c and avoid
a compile error when building kernel for n8x0.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/tusb6010.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -29,19 +29,6 @@ static void tusb_source_power(struct mus
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


