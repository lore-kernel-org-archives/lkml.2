Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2IRS0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:26:13 -0400
Received: from mail-fa0-f74.google.com ([209.85.161.74]:53066 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab2IRSYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:24:34 -0400
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Cc: "kgene.kim" <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Prathyush K <prathyush.k@samsung.com>, Simon Glass <sjg@chromium.org>
Subject: [PATCH 1/7] PM / Domains: add generic function 'pm_genpd_of_add_device_by_name'
Date: Tue, 18 Sep 2012 11:21:53 -0700
Message-Id: <1347992519-6904-2-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1347992519-6904-1-git-send-email-sjg@chromium.org>
References: <1347992519-6904-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Prathyush K <prathyush.k@samsung.com>

A new function pm_genpd_of_add_device_by_name is added to the pm_domain
file. This function takes three parameters - target device to be added to
genpd, a device node and the name of the property. This function reads
the "propname" property from the device node and finds the corresponding
genpd device node. The target device is then added to this genpd by
calling __pm_genpd_of_add_device.

of_property_read_u32(dev_node, propname, &val);
genpd_node = of_find_node_by_phandle(val);
__pm_genpd_of_add_device(genpd_node, dev, NULL);

Signed-off-by: Prathyush K <prathyush.k@samsung.com>
Signed-off-by: Simon Glass <sjg@chromium.org>
Tested-by: Prathyush Kalashwaram <prathyush@chromium.org>
---
 include/linux/pm_domain.h |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index 30f794e..c733ece 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -137,6 +137,18 @@ static inline int pm_genpd_add_device(struct generic_pm_domain *genpd,
 	return __pm_genpd_add_device(genpd, dev, NULL);
 }
 
+static inline int pm_genpd_of_add_device_by_name(
+					struct device_node *dev_node,
+					struct device *dev,
+					char *propname)
+{
+	u32 val;
+	struct device_node *genpd_node;
+	of_property_read_u32(dev_node, propname, &val);
+	genpd_node = of_find_node_by_phandle(val);
+	return __pm_genpd_of_add_device(genpd_node, dev, NULL);
+}
+
 static inline int pm_genpd_of_add_device(struct device_node *genpd_node,
 					 struct device *dev)
 {
@@ -184,6 +196,13 @@ static inline int pm_genpd_add_device(struct generic_pm_domain *genpd,
 {
 	return -ENOSYS;
 }
+static inline int pm_genpd_of_add_device_by_name(
+					struct device_node *dev_node,
+					struct device *dev,
+					char *propname)
+{
+	return -ENOSYS;
+}
 static inline int pm_genpd_remove_device(struct generic_pm_domain *genpd,
 					 struct device *dev)
 {
-- 
1.7.7.3

