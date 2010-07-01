Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab0GACcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 22:32:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59510 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab0GACcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 22:32:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=L5AcACrnkpGbdsjpUi4MtnaQvLp21Na/YPLlWNcoun+1LTfHQCjdxtW18Gj6BfgkZw
         Qewro93pL351Cwyu6v4PbuzkKRFZQ3x/2wjGWVkuTdgryE/sT/kRJz4jQ2Yol7FpCFNJ
         09QkcFskWMPvsAK1zAzTQRTWqtLqTloSpzRrM=
Subject: [PATCH] dmi-id: fix a memory leak in dmi_id_init error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain
Date: Thu, 01 Jul 2010 10:35:07 +0800
Message-Id: <1277951707.30073.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a missing kfree(dmi_dev) in dmi_id_init error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/firmware/dmi-id.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
index a777a35..94a58a0 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -229,10 +229,12 @@ static int __init dmi_id_init(void)
 
 	ret = device_register(dmi_dev);
 	if (ret)
-		goto fail_class_unregister;
+		goto fail_free_dmi_dev;
 
 	return 0;
 
+fail_free_dmi_dev:
+	kfree(dmi_dev);
 fail_class_unregister:
 
 	class_unregister(&dmi_class);
-- 
1.5.4.3



