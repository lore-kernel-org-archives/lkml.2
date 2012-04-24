Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2DXLgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 07:36:03 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:56699 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753982Ab2DXLeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 07:34:36 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <akpm@linux-foundation.org>
Cc: <spear-devel@list.st.com>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <mturquette@linaro.org>, <sshtylyov@mvista.com>, <jgarzik@redhat.com>,
        <linux@arm.linux.org.uk>, Viresh Kumar <viresh.kumar@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH V3 04/12] usb/marvell: Remove conditional compilation of clk code
Date: Tue, 24 Apr 2012 16:51:26 +0530
Message-ID: <ac4280d4e8323e86982e6a3ceed93a2e7f30e52e.1335266056.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1335266056.git.viresh.kumar@st.com>
References: <cover.1335266056.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.linux@gmail.com>

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in clk.h,
there is no need to have clk code enclosed in #ifdef CONFIG_HAVE_CLK, #endif
macros.

Marvell usb also has these dummy macros defined locally. Remove them as they
aren't required anymore.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
 include/linux/platform_data/mv_usb.h |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/include/linux/platform_data/mv_usb.h b/include/linux/platform_data/mv_usb.h
index d94804a..944b01d 100644
--- a/include/linux/platform_data/mv_usb.h
+++ b/include/linux/platform_data/mv_usb.h
@@ -52,13 +52,4 @@ struct mv_usb_platform_data {
 	int	(*set_vbus)(unsigned int vbus);
 	int     (*private_init)(void __iomem *opregs, void __iomem *phyregs);
 };
-
-#ifndef CONFIG_HAVE_CLK
-/* Dummy stub for clk framework */
-#define clk_get(dev, id)       NULL
-#define clk_put(clock)         do {} while (0)
-#define clk_enable(clock)      do {} while (0)
-#define clk_disable(clock)     do {} while (0)
-#endif
-
 #endif
-- 
1.7.9

