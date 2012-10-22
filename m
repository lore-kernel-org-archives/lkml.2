Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab2JVP4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:56:17 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6685 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2JVP4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:56:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 22 Oct 2012 08:56:13 -0700
From: Denis Kirjanov <kirjanov@gmail.com>
To: dougthompson@xmission.com
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Denis Kirjanov <kirjanov@gmail.com>
Subject: [PATCH] check the kzalloc return value
Date: Mon, 22 Oct 2012 19:56:04 +0400
Message-ID: <1350921364-26366-1-git-send-email-kirjanov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
---
 drivers/edac/edac_mc_sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index ed0bc07..55ce016 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -1128,7 +1128,8 @@ int __init edac_mc_sysfs_init(void)
 	}
 
 	mci_pdev = kzalloc(sizeof(*mci_pdev), GFP_KERNEL);
-
+	if (!mci_pdev)
+		return -ENOMEM;
 	mci_pdev->bus = edac_subsys;
 	mci_pdev->type = &mc_attr_type;
 	device_initialize(mci_pdev);
-- 
1.7.9.5

