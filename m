Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848Ab3AIUk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:40:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:43326 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933806Ab3AIUkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Marc Zyngier <marc.zyngier@arm.com>,
        Florian Fainelli <florian@openwrt.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 68/80] ARM: 7607/1: realview: fix private peripheral memory base for EB rev. B boards
Date: Wed,  9 Jan 2013 12:36:00 -0800
Message-Id: <20130109201509.124623383@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit e6ee4b2b57a8e0d8e551031173de080b338d3969 upstream.

Commit 34ae6c96a6a7 ("ARM: 7298/1: realview: fix mapping of MPCore
private memory region") accidentally broke the definition for the base
address of the private peripheral region on revision B Realview-EB
boards.

This patch uses the correct address for REALVIEW_EB11MP_PRIV_MEM_BASE.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-realview/include/mach/board-eb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-realview/include/mach/board-eb.h
+++ b/arch/arm/mach-realview/include/mach/board-eb.h
@@ -47,7 +47,7 @@
 #define REALVIEW_EB_USB_BASE		0x4F000000	/* USB */
 
 #ifdef CONFIG_REALVIEW_EB_ARM11MP_REVB
-#define REALVIEW_EB11MP_PRIV_MEM_BASE	0x1F000000
+#define REALVIEW_EB11MP_PRIV_MEM_BASE	0x10100000
 #define REALVIEW_EB11MP_L220_BASE	0x10102000	/* L220 registers */
 #define REALVIEW_EB11MP_SYS_PLD_CTRL1	0xD8		/* Register offset for MPCore sysctl */
 #else


