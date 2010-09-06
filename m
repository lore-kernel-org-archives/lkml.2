Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab0IFOgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:36:04 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33492 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755Ab0IFOf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:35:59 -0400
Date: Mon, 6 Sep 2010 16:35:54 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: Lennert Buytenhek <kernel@wantstofly.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 01/14] arch/arm: Removing undead ifdef __ASSEMBLY__
Message-ID: <e09809579db119258c1cd1c7dd9bd95859aa9894.1283782700.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __ASSEMBLY__ ifdef isn't necessary at this point, because it is
checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 arch/arm/mach-ixp23xx/include/mach/platform.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-ixp23xx/include/mach/platform.h b/arch/arm/mach-ixp23xx/include/mach/platform.h
index db9d941..9f05ea4 100644
--- a/arch/arm/mach-ixp23xx/include/mach/platform.h
+++ b/arch/arm/mach-ixp23xx/include/mach/platform.h
@@ -43,7 +43,6 @@ extern struct sys_timer ixp23xx_timer;
 
 #define IXP23XX_UART_XTAL		14745600
 
-#ifndef __ASSEMBLY__
 /*
  * Is system memory on the XSI or CPP bus?
  */
@@ -51,7 +50,5 @@ static inline unsigned ixp23xx_cpp_boot(void)
 {
 	return (*IXP23XX_EXP_CFG0 & IXP23XX_EXP_CFG0_XSI_NOT_PRES);
 }
-#endif
-
 
 #endif
-- 
1.7.0.4

