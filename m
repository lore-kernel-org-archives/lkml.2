Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab1HKItx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:49:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63009 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab1HKItw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:49:52 -0400
Subject: [PATCH RESEND] Input: tegra-kbc - correct call to input_free_device
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rakesh Iyer <riyer@nvidia.com>, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 16:49:29 +0800
Message-ID: <1313052569.2139.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kzalloc for kbc fails, then we have NULL pointer dereference while
calling input_free_device(kbc->idev) in the error handling.
So it is safer to always use the original name, input_dev.

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



