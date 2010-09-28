Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab0I1HDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 03:03:24 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:46138 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712Ab0I1HDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 03:03:24 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 1/2] DMAENGINE: define a dummy filter function for coh901318
Date: Tue, 28 Sep 2010 09:03:12 +0200
Message-ID: <1285657392-28937-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All platform data has to be made conditional on
as to avoid cluttering the code with other #ifdef:s.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-u300/include/mach/coh901318.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-u300/include/mach/coh901318.h b/arch/arm/mach-u300/include/mach/coh901318.h
index 193da2d..a90484e 100644
--- a/arch/arm/mach-u300/include/mach/coh901318.h
+++ b/arch/arm/mach-u300/include/mach/coh901318.h
@@ -102,6 +102,7 @@ struct coh901318_platform {
 	const int max_channels;
 };
 
+#ifdef CONFIG_COH901318
 /**
  * coh901318_filter_id() - DMA channel filter function
  * @chan: dma channel handle
@@ -110,6 +111,12 @@ struct coh901318_platform {
  * In dma_request_channel() it specifies what channel id to be requested
  */
 bool coh901318_filter_id(struct dma_chan *chan, void *chan_id);
+#else
+static inline bool coh901318_filter_id(struct dma_chan *chan, void *chan_id)
+{
+	return false;
+}
+#endif
 
 /*
  * DMA Controller - this access the static mappings of the coh901318 dma.
-- 
1.6.3.3

