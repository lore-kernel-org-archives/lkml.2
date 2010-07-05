Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0GEBfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 21:35:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:32872 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab0GEBfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 21:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=j8RvFh3rl0jEXFzwekv8sbBs0z1vEkYYqyoCjACJNQLNquFjx9wv5BEGWsFJzeTOrH
         ALuc/aw3ccGCBkPOr37VwNO6zKbJBLafZS2kAfNrv+ITG6IZYA+S8ZE7ufwVbkiCyZDA
         3CvZFRs4AhQ7DaU9A2HX8GZeMyI3CZyC5VFQk=
Subject: [PATCH] dcdbas: remove a redundant smi_data_buf_free in dcdbas_exit
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>,
       Chris Wright <chrisw@sous-sol.org>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain
Date: Mon, 05 Jul 2010 09:35:47 +0800
Message-Id: <1278293747.12801.7.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 03828286561e3d39cacfb831b2f303a047a6f787 Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 5 Jul 2010 09:26:30 +0800
Subject: [PATCH] dcdbas: remove a redundant smi_data_buf_free in dcdbas_exit

smi_data_buf_free is called twice in current implementation.
The second call simply return because smi_data_buf is set to NULL in first call.
This patch removes the second smi_data_buf_free call.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
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
1.5.4.3



