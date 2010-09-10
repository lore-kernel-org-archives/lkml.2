Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab0IJKLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:11:22 -0400
Received: from mail.df.lth.se ([194.47.250.12]:39147 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752112Ab0IJKLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:11:21 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] DMAENGINE: make sure we can always define platform data
Date: Fri, 10 Sep 2010 12:13:06 +0200
Message-Id: <1284113586-25808-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you try to compile platform data structs for the PL08X without
it being compiled in, symbol resoltion will fail on the filter
function when linking the kernel, so provide a dummy function.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
Dan, this goes on top of the other stuff queued on top of the
PL08X driver merged for next. Feel free to squash this too if
you prefer.
---
 include/linux/amba/pl08x.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
index 8435f4a..daee6d0 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -179,6 +179,13 @@ struct pl08x_platform_data {
 	void (*put_signal)(struct pl08x_dma_chan *);
 };
 
+#ifdef CONFIG_AMBA_PL08X
 bool pl08x_filter_id(struct dma_chan *chan, void *chan_id);
+#else
+static bool pl08x_filter_id(struct dma_chan *chan, void *chan_id)
+{
+	return false;
+}
+#endif
 
 #endif	/* AMBA_PL08X_H */
-- 
1.7.2.2

