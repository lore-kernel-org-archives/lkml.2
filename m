Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab2ALIsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 03:48:03 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:34120 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698Ab2ALIsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 03:48:00 -0500
From: Rajeev Kumar <rajeev-dlh.kumar@st.com>
To: <viresh.kumar@st.com>, <vinod.koul@intel.com>
Cc: <linus.walleij@linaro.org>, <mirko.gardi@st.com>, <bhupesh.sharma@st.com>,
        <deepak.sikri@st.com>, <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <vipulkumar.samar@st.com>, <pratyush.anand@st.com>,
        <rajeev-dlh.kumar@st.com>, <armando.visconti@st.com>,
        <dan.j.williams@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>
Subject: [PATCH V2] dmaengine/dw_dmac: Hibernation support in dw_dmac
Date: Thu, 12 Jan 2012 14:17:35 +0530
Message-ID: <1326358055-6576-1-git-send-email-rajeev-dlh.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The suspend and resume implementation is through dev_pm_ops in dmac. So
in order to support hibernation, freeze, thaw, restore and poweroff
features are required.

Signed-off-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 9b592b0..3a3d7ed 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1562,6 +1562,10 @@ static int dw_resume_noirq(struct device *dev)
 static const struct dev_pm_ops dw_dev_pm_ops = {
 	.suspend_noirq = dw_suspend_noirq,
 	.resume_noirq = dw_resume_noirq,
+	.freeze_noirq = dw_suspend_noirq,
+	.thaw_noirq = dw_resume_noirq,
+	.restore_noirq = dw_resume_noirq,
+	.poweroff_noirq = dw_suspend_noirq,
 };
 
 static struct platform_driver dw_driver = {
-- 
1.7.2.2

