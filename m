Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2AKGXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 01:23:35 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:58214 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165Ab2AKGXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 01:23:33 -0500
From: Rajeev Kumar <rajeev-dlh.kumar@st.com>
To: <viresh.kumar@st.com>
Cc: <linus.walleij@linaro.org>, <mirko.gardi@st.com>, <bhupesh.sharma@st.com>,
        <deepak.sikri@st.com>, <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <vipulkumar.samar@st.com>, <pratyush.anand@st.com>,
        <rajeev-dlh.kumar@st.com>, <armando.visconti@st.com>,
        <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>
Subject: [PATCH] dmaengine/dw_dmac: Hibernation support in dw_dmac
Date: Wed, 11 Jan 2012 11:53:09 +0530
Message-ID: <1326262989-18608-1-git-send-email-rajeev-dlh.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The suspend and resume implementation is through dev_pm_ops in dmac. So
in order to support hibernation, freeze, thaw and restore features are required.

Signed-off-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
---
 drivers/dma/dw_dmac.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index d2e1c25..cb346d6 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1568,6 +1568,9 @@ static int dw_resume_noirq(struct device *dev)
 static const struct dev_pm_ops dw_dev_pm_ops = {
 	.suspend_noirq = dw_suspend_noirq,
 	.resume_noirq = dw_resume_noirq,
+	.freeze_noirq = dw_suspend_noirq,
+	.thaw_noirq =	dw_resume_noirq,
+	.restore_noirq = dw_resume_noirq,
 };
 
 static struct platform_driver dw_driver = {
-- 
1.6.0.2

