Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab0HEWdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:33:36 -0400
Received: from kroah.org ([198.145.64.141]:37777 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934542Ab0HEWYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Axel Lin <axel.lin@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/28] dcdbas: remove a redundant smi_data_buf_free in dcdbas_exit
Date: Thu,  5 Aug 2010 15:24:05 -0700
Message-Id: <1281047058-23716-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>

smi_data_buf_free is called twice in current implementation.
The second call simply return because smi_data_buf is set to NULL in first call.
This patch removes the second smi_data_buf_free call.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/dcdbas.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index aa9bc9e..69ad529 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -634,9 +634,6 @@ static void __exit dcdbas_exit(void)
 	 * before platform_device_unregister
 	 */
 	unregister_reboot_notifier(&dcdbas_reboot_nb);
-	smi_data_buf_free();
-	platform_device_unregister(dcdbas_pdev);
-	platform_driver_unregister(&dcdbas_driver);
 
 	/*
 	 * We have to free the buffer here instead of dcdbas_remove
@@ -645,6 +642,8 @@ static void __exit dcdbas_exit(void)
 	 * released.
 	 */
 	smi_data_buf_free();
+	platform_device_unregister(dcdbas_pdev);
+	platform_driver_unregister(&dcdbas_driver);
 }
 
 module_init(dcdbas_init);
-- 
1.7.2

