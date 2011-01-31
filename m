Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1AaP0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:26:00 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:41486 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab1AaPZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:25:59 -0500
From: Thomas Chou <thomas@wytron.com.tw>
To: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH 1/3] of: define dummy of_get_property if not CONFIG_OF
Date: Mon, 31 Jan 2011 23:25:49 +0800
Message-Id: <1296487551-30938-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <AANLkTimS70uHqmv3jhr+7mPz4QFKXRXuFnWj8s3EpKsO@mail.gmail.com>
References: <AANLkTimS70uHqmv3jhr+7mPz4QFKXRXuFnWj8s3EpKsO@mail.gmail.com>
X-SA-Exim-Connect-IP: 192.168.1.250
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will help to reduce the ifdef CONFIG_OF needed in most
platform data probing.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
 include/linux/of.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index cad7cf0..5e122cb 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -222,5 +222,13 @@ extern void of_attach_node(struct device_node *);
 extern void of_detach_node(struct device_node *);
 #endif
 
+#else /* !CONFIG_OF */
+
+static inline const void *of_get_property(const struct device_node *node,
+				const char *name, int *lenp)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_OF */
 #endif /* _LINUX_OF_H */
-- 
1.7.3.5

