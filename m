Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab2EBJi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:38:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49837 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070Ab2EBJiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:38:54 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] extcon: Add EXTCON_MECHANICAL cable type for physical presence
Date: Wed,  2 May 2012 10:38:51 +0100
Message-Id: <1335951531-5967-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some accessory detection mechanisms are able to detect that something is
physically present in the socket separately to identifying what is present
in the socket. This information can be useful to applications, for example
allowing them to indicate that a potentially broken accessory is present,
so provide a standard way to report it to userspace.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon_class.c |    1 +
 include/linux/extcon.h        |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index 53c64a9..a7116e8 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -60,6 +60,7 @@ const char *extcon_cable_name[] = {
 	[EXTCON_SPDIF_OUT]	= "SPDIF-out",
 	[EXTCON_VIDEO_IN]	= "Video-in",
 	[EXTCON_VIDEO_OUT]	= "Video-out",
+	[EXTCON_MECHANICAL]	= "Mechanical",
 
 	NULL,
 };
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 6495f77..cdd4014 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -66,6 +66,7 @@ enum extcon_cable_name {
 	EXTCON_SPDIF_OUT,
 	EXTCON_VIDEO_IN,
 	EXTCON_VIDEO_OUT,
+	EXTCON_MECHANICAL,
 };
 extern const char *extcon_cable_name[];
 
-- 
1.7.10

