Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab2EHENY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:13:24 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:34257 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119Ab2EHEJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:09:36 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <akpm@linux-foundation.org>
Cc: <spear-devel@list.st.com>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <mturquette@linaro.org>, <sshtylyov@mvista.com>, <jgarzik@redhat.com>,
        <linux@arm.linux.org.uk>, <w.sang@pengutronix.de>,
        <LW@KARO-electronics.de>, <andrew@lunn.ch>,
        Viresh Kumar <viresh.kumar@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH V3 Resend 05/12] usb/musb: Remove conditional compilation of clk code
Date: Tue, 8 May 2012 09:22:32 +0530
Message-ID: <ead52d9fcc8c2bcb1c9dbdc12296a701592004c4.1336448639.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1336448639.git.viresh.kumar@st.com>
References: <cover.1336448639.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.linux@gmail.com>

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in clk.h,
there is no need to have clk code enclosed in #ifdef CONFIG_HAVE_CLK, #endif
macros.

musb also has these dummy macros defined locally. Remove them as they aren't
required anymore.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/musb/musb_core.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index f4a40f0..f7bc23f 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -81,14 +81,6 @@ struct musb_ep;
 #define is_peripheral_active(m)		(!(m)->is_host)
 #define is_host_active(m)		((m)->is_host)
 
-#ifndef CONFIG_HAVE_CLK
-/* Dummy stub for clk framework */
-#define clk_get(dev, id)	NULL
-#define clk_put(clock)		do {} while (0)
-#define clk_enable(clock)	do {} while (0)
-#define clk_disable(clock)	do {} while (0)
-#endif
-
 #ifdef CONFIG_PROC_FS
 #include <linux/fs.h>
 #define MUSB_CONFIG_PROC_FS
-- 
1.7.9

