Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab1HEKDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:03:53 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:56205 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764Ab1HEKDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:03:52 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linus.walleij@linaro.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <alim.akhtar@gmail.com>
Subject: [PATCH V3 01/20] ARM: asm/pl080.h: Protect against multiple inclusion of header file
Date: Fri, 5 Aug 2011 15:32:26 +0530
Message-ID: <4197035d67eead4da9eaf253ed6eca9d5630b544.1312538034.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312538034.git.viresh.kumar@st.com>
References: <cover.1312538034.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<asm/hardware/pl080.h> doesn't have protection to deal with multiple inclusion.
And so we get compilation errors in cases where this file is included more than
once. This patch adds #ifdefs at the top of file to protect it against multiple
inclusions.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/include/asm/hardware/pl080.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/hardware/pl080.h b/arch/arm/include/asm/hardware/pl080.h
index e4a04e4..33c78d7 100644
--- a/arch/arm/include/asm/hardware/pl080.h
+++ b/arch/arm/include/asm/hardware/pl080.h
@@ -21,6 +21,9 @@
  * OneNAND features.
 */
 
+#ifndef ASM_PL080_H
+#define ASM_PL080_H
+
 #define PL080_INT_STATUS			(0x00)
 #define PL080_TC_STATUS				(0x04)
 #define PL080_TC_CLEAR				(0x08)
@@ -138,3 +141,4 @@ struct pl080s_lli {
 	u32	control1;
 };
 
+#endif /* ASM_PL080_H */
-- 
1.7.2.2

