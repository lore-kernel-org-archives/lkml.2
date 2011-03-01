Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab1CAUMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:12:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36981 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757400Ab1CAUMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:12:32 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] mfd: Add platform data to support multiple WM831x devices per board
Date: Tue,  1 Mar 2011 20:12:46 +0000
Message-Id: <1299010366-31453-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299010366-31453-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1299010366-31453-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a system contains multiple WM831x devices we need to pass a device
number through to the MFD so that we use unique device IDs when we
instantiate child devices. In order to get support for this into 2.6.39
add some platform data to support the configuration, but no implementation
as yet.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/wm831x/pdata.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/wm831x/pdata.h b/include/linux/mfd/wm831x/pdata.h
index ac3aa73..afe4db4 100644
--- a/include/linux/mfd/wm831x/pdata.h
+++ b/include/linux/mfd/wm831x/pdata.h
@@ -104,6 +104,9 @@ struct wm831x_watchdog_pdata {
 #define WM831X_MAX_ISINK  2
 
 struct wm831x_pdata {
+	/** Used to distinguish multiple WM831x chips */
+	int wm831x_num;
+
 	/** Called before subdevices are set up */
 	int (*pre_init)(struct wm831x *wm831x);
 	/** Called after subdevices are set up */
-- 
1.7.2.3

