Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab0EFRj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:39:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759368Ab0EFRiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:38:12 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com,
       Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 12/13] drivers/usb/musb: removing redundant ifdefs
Date: Thu,  6 May 2010 19:36:16 +0200
Message-Id: <1273167377-14270-13-git-send-email-jolsa@redhat.com>
In-Reply-To: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
References: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 drivers/usb/musb/musb_core.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index ac17b00..8ddcd41 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -468,10 +468,7 @@ struct musb_csr_regs {
 };
 
 struct musb_context_registers {
-
-#ifdef CONFIG_PM
 	u32 otg_sysconfig, otg_forcestandby;
-#endif
 	u8 power;
 	u16 intrtxe, intrrxe;
 	u8 intrusbe;
@@ -483,16 +480,10 @@ struct musb_context_registers {
 	struct musb_csr_regs index_regs[MUSB_C_NUM_EPS];
 };
 
-#ifdef CONFIG_PM
 extern void musb_platform_save_context(struct musb *musb,
 		struct musb_context_registers *musb_context);
 extern void musb_platform_restore_context(struct musb *musb,
 		struct musb_context_registers *musb_context);
-#else
-#define musb_platform_save_context(m, x)	do {} while (0)
-#define musb_platform_restore_context(m, x)	do {} while (0)
-#endif
-
 #endif
 
 static inline void musb_set_vbus(struct musb *musb, int is_on)
-- 
1.6.6.1

