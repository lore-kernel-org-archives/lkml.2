Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab0JAMAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:00:07 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:52083 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932374Ab0JAL77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:59:59 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Viresh Kumar <viresh.kumar@st.com>, shiraz.hashim@st.com,
        vipin.kumar@st.com, deepak.sikri@st.com, armando.visconti@st.com,
        vipulkumar.samar@st.com, rajeev-dlh.kumar@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com
Subject: [PATCH V2 48/69] ST SPEAr: replace readl, writel with __raw_readl, __raw_writel in uncompress.h
Date: Fri,  1 Oct 2010 17:26:08 +0530
Message-Id: <10581ee8e7ad68eabb4421cee448b5f7df983adb.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

readl also calls outer cache maintainance operations which are not available
during Linux uncompression. This patch replaces readl, writel with __raw_readl
and __raw_writel.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/plat-spear/include/plat/uncompress.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-spear/include/plat/uncompress.h b/arch/arm/plat-spear/include/plat/uncompress.h
index 99ba678..963aa5b 100644
--- a/arch/arm/plat-spear/include/plat/uncompress.h
+++ b/arch/arm/plat-spear/include/plat/uncompress.h
@@ -24,10 +24,10 @@ static inline void putc(int c)
 {
 	void __iomem *base = (void __iomem *)SPEAR_DBG_UART_BASE;
 
-	while (readl(base + UART01x_FR) & UART01x_FR_TXFF)
+	while (__raw_readl(base + UART01x_FR) & UART01x_FR_TXFF)
 		barrier();
 
-	writel(c, base + UART01x_DR);
+	__raw_writel(c, base + UART01x_DR);
 }
 
 static inline void flush(void)
-- 
1.7.2.2

