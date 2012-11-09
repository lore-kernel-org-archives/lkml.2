Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab2KIP0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:26:39 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52532 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2KIP0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:26:37 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: vinod.koul@intel.com
Cc: djbw@fb.com, linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Deepak Sikri <deepak.sikri@st.com>
Subject: [PATCH] dmaengine/dmatest: terminate transfers only in case of errors
Date: Fri,  9 Nov 2012 20:56:29 +0530
Message-Id: <1f83c56ebbe66c00acc7901613da1dc6fdba4a6b.1352474736.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shiraz Hashim <shiraz.hashim@st.com>

dmatest erroneously terminated transfers in normal cases also leading to
test failures for multiple threads over a channel. Fix this and
terminate transfers only in case of errors.

Signed-off-by: Shiraz Hashim <shiraz.hashim@st.com>
Signed-off-by: Deepak Sikri <deepak.sikri@st.com>
---
 drivers/dma/dmatest.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 8f130d4e..ce58b8e 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -509,7 +509,9 @@ err_srcs:
 			thread_name, total_tests, failed_tests, ret);
 
 	/* terminate all transfers on specified channels */
-	chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+	if (ret)
+		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+
 	if (iterations > 0)
 		while (!kthread_should_stop()) {
 			DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait_dmatest_exit);
-- 
1.7.12.rc2.18.g61b472e

