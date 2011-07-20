Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab1GTHw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 03:52:59 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34046 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab1GTHw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 03:52:57 -0400
Subject: [PATCH] Input: tegra-kbc - correct call to input_free_device
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rakesh Iyer <riyer@nvidia.com>, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 15:52:52 +0800
Message-ID: <1311148372.10091.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This error handling code can be reached before kbc->idev is
initialized, so it is safer to always use the original name,
input_dev.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/keyboard/tegra-kbc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index 2b3b73e..8e40f2b 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -701,7 +701,7 @@ err_iounmap:
 err_free_mem_region:
 	release_mem_region(res->start, resource_size(res));
 err_free_mem:
-	input_free_device(kbc->idev);
+	input_free_device(input_dev);
 	kfree(kbc);
 
 	return err;
-- 
1.7.4.1



