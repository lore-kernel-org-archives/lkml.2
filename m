Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973Ab2JYPne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:43:34 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14192 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759958Ab2JYPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:43:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 25 Oct 2012 08:43:31 -0700
From: Denis Kirjanov <kirjanov@gmail.com>
To: dougthompson@xmission.com
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        kirjanov@gmail.com
Subject: [PATCH 2/2] don't leak memory for mci_pdev
Date: Thu, 25 Oct 2012 19:43:23 +0400
Message-ID: <1351179803-6625-1-git-send-email-kirjanov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't leak allocated memory for mci_pdev

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
---
 drivers/edac/edac_mc_sysfs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index ea34ece..689d7ba 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -1141,12 +1141,14 @@ int __init edac_mc_sysfs_init(void)
 
 	err = device_add(mci_pdev);
 	if (err < 0)
-		return err;
+		goto out_dev_free;
 
 	edac_dbg(0, "device %s created\n", dev_name(mci_pdev));
 
 	return 0;
 
+out_dev_free:
+	kfree(mci_pdev);
 out_put_sysfs:
 	edac_put_sysfs_subsys();
 out:
@@ -1158,4 +1160,5 @@ void __exit edac_mc_sysfs_exit(void)
 	put_device(mci_pdev);
 	device_del(mci_pdev);
 	edac_put_sysfs_subsys();
+	kfree(mci_pdev);
 }
-- 
1.7.9.5

