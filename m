Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0ESRX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:23:57 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50837 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab0ESRXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:23:54 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       Daniel Mack <daniel@caiaq.de>, Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 2/4] input: add static inline helpers for ABS properties
Date: Wed, 19 May 2010 19:22:35 +0200
Message-Id: <1274289757-2723-3-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for dynamically allocated ABS axis, introduce a number of
sttaic inline access helpers. This should make the transition less
painful.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 include/linux/input.h |   60 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/include/linux/input.h b/include/linux/input.h
index 0e41f77..ff1ee6d 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1188,6 +1188,66 @@ struct input_dev {
 };
 #define to_input_dev(d) container_of(d, struct input_dev, dev)
 
+static inline int input_abs(struct input_dev *dev, int axis)
+{
+	return dev->abs[axis];
+}
+
+static inline int input_abs_max(struct input_dev *dev, int axis)
+{
+	return dev->absmax[axis];
+}
+
+static inline int input_abs_min(struct input_dev *dev, int axis)
+{
+	return dev->absmin[axis];
+}
+
+static inline int input_abs_fuzz(struct input_dev *dev, int axis)
+{
+	return dev->absfuzz[axis];
+}
+
+static inline int input_abs_flat(struct input_dev *dev, int axis)
+{
+	return dev->absflat[axis];
+}
+
+static inline int input_abs_res(struct input_dev *dev, int axis)
+{
+	return dev->absres[axis];
+}
+
+static inline void input_abs_set(struct input_dev *dev, int axis, int val)
+{
+	dev->abs[axis] = val;
+}
+
+static inline void input_abs_set_max(struct input_dev *dev, int axis, int val)
+{
+	dev->absmax[axis] = val;
+}
+
+static inline void input_abs_set_min(struct input_dev *dev, int axis, int val)
+{
+	dev->absmin[axis] = val;
+}
+
+static inline void input_abs_set_fuzz(struct input_dev *dev, int axis, int val)
+{
+	dev->absfuzz[axis] = val;
+}
+
+static inline void input_abs_set_flat(struct input_dev *dev, int axis, int val)
+{
+	dev->absflat[axis] = val;
+}
+
+static inline void input_abs_set_res(struct input_dev *dev, int axis, int val)
+{
+	dev->absres[axis] = val;
+}
+
 /*
  * Verify that we are in sync with input_device_id mod_devicetable.h #defines
  */
-- 
1.7.1

