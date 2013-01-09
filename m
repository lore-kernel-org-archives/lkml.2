Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab3AINkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 08:40:11 -0500
Received: from mx1.zhaw.ch ([160.85.104.50]:47701 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757436Ab3AINkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 08:40:10 -0500
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2013 08:40:10 EST
From: Tobias Klauser <tklauser@distanz.ch>
To: Jamie Iles <jamie@jamieiles.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] ARM: picoxcell: remove unnecessary header common.h
Date: Wed,  9 Jan 2013 14:31:13 +0100
Message-Id: <1357738273-20842-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.5.4
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2013.1.9.131818
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1800_1899 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, RDNS_NXDOMAIN 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __ANY_URI 0, __CP_POSSIBLE_EXPLOIT_SUBJ 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 66314223 ("ARM: socfpga: initial support for Altera's
SOCFPGA platform") struct sys_timer dw_apb_timer is an extern in
<linux/dw_apb_timer.h>, so there is no need for common.h anymore,
instead directly #include <asm/mach/time.h> in common.c

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Acked-by: Jamie Iles <jamie@jamieiles.com>
---

I looks like this hasn't made it into -next yet, thus I'm resending
the patch already submitted on 5 October 2012 (with Jamie's ACK added).

 arch/arm/mach-picoxcell/common.c |    3 +--
 arch/arm/mach-picoxcell/common.h |   17 -----------------
 2 files changed, 1 insertions(+), 19 deletions(-)
 delete mode 100644 arch/arm/mach-picoxcell/common.h

diff --git a/arch/arm/mach-picoxcell/common.c b/arch/arm/mach-picoxcell/common.c
index f6c0849..bc36f12 100644
--- a/arch/arm/mach-picoxcell/common.c
+++ b/arch/arm/mach-picoxcell/common.c
@@ -19,8 +19,7 @@
 #include <asm/mach/arch.h>
 #include <asm/hardware/vic.h>
 #include <asm/mach/map.h>
-
-#include "common.h"
+#include <asm/mach/time.h>
 
 #define PHYS_TO_IO(x)			(((x) & 0x00ffffff) | 0xfe000000)
 #define PICOXCELL_PERIPH_BASE		0x80000000
diff --git a/arch/arm/mach-picoxcell/common.h b/arch/arm/mach-picoxcell/common.h
deleted file mode 100644
index a65cb02..0000000
--- a/arch/arm/mach-picoxcell/common.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/*
- * Copyright (c) 2011 Picochip Ltd., Jamie Iles
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * All enquiries to support@picochip.com
- */
-#ifndef __PICOXCELL_COMMON_H__
-#define __PICOXCELL_COMMON_H__
-
-#include <asm/mach/time.h>
-
-extern struct sys_timer dw_apb_timer;
-
-#endif /* __PICOXCELL_COMMON_H__ */
-- 
1.7.5.4

