Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964906Ab1JFMv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 08:51:26 -0400
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:48440 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964879Ab1JFMvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 08:51:25 -0400
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Oct 2011 08:51:25 EDT
Subject: [PATCH] of: include errno.h
To: grant.likely@secretlab.ca
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Oct 2011 15:40:44 +0300
Message-ID: <20111006124044.1066.7111.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling ath6kl for beagleboard (omap2plus_defconfig plus
CONFIG_ATH6KL, CONFIG_OF disable) with current linux-next compilation
fails:

include/linux/of.h:269: error: 'ENOSYS' undeclared (first use in this function)
include/linux/of.h:276: error: 'ENOSYS' undeclared (first use in this function)
include/linux/of.h:289: error: 'ENOSYS' undeclared (first use in this function)

Fix this by including errno.h from of.h.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 include/linux/of.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 9180dc5..219c29d 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -17,6 +17,7 @@
  */
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/errno.h>
 #include <linux/kref.h>
 #include <linux/mod_devicetable.h>
 #include <linux/spinlock.h>

