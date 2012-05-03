Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab2ECO2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:28:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53883 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab2ECOZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:25:01 -0400
From: Venkatraman S <svenkatr@ti.com>
To: <linux-mmc@vger.kernel.org>, <cjb@laptop.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <arnd.bergmann@linaro.org>,
        <alex.lemberg@sandisk.com>, <ilan.smith@sandisk.com>,
        <lporzio@micron.com>, <rmk+kernel@arm.linux.org.uk>,
        Venkatraman S <svenkatr@ti.com>
Subject: [PATCH v2 13/16] mmc: Documentation: Add sysfs ABI for hpi_time_threshold
Date: Thu, 3 May 2012 19:53:12 +0530
Message-ID: <1336054995-22988-14-git-send-email-svenkatr@ti.com>
X-Mailer: git-send-email 1.7.10.rc2
In-Reply-To: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpi_time_threshold can be set to configure elapsed time in ms,
after which an ongoing request will not be preempted.
Explain the hpi_time_threhold parameter for MMC devices.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
---
 Documentation/ABI/testing/sysfs-devices-mmc |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-mmc b/Documentation/ABI/testing/sysfs-devices-mmc
index 5a50ab6..133dba5 100644
--- a/Documentation/ABI/testing/sysfs-devices-mmc
+++ b/Documentation/ABI/testing/sysfs-devices-mmc
@@ -19,3 +19,15 @@ Description:
 		is enabled, this attribute will indicate the size of enhanced
 		data area. If not, this attribute will be -EINVAL.
 		Unit KByte. Format decimal.
+
+What:		/sys/devices/.../mmc_host/mmcX/mmcX:XXXX/hpi_time_threshold
+Date:		April 2012
+Contact:	Venkatraman S <svenkatr@ti.com>
+Description:
+		High Priority Interrupt is a new feature defined in eMMC4.4
+		standard. If this feature is enabled, stack needs to decide
+		till what time since the last issued request is considered
+		preemptible. This attribute value (in milliseconds) is
+		used for arriving at the most optimal value for a specific
+		card. Default is zero, which also disables the feature, as
+		the request becomes non-preemptible immediately.
-- 
1.7.10.rc2

