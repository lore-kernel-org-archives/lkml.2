Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab1L2JC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 04:02:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41155 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab1L2JCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 04:02:19 -0500
Message-ID: <1325149328.7012.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: Fix the error handling if create_regulator
 fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 29 Dec 2011 17:02:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of create_regulator() fails, goto the error path immediately.
It does not make sense to update rdev->open_count if create_regulator fails.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index dbdebed6..fb6ea9b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1282,6 +1282,7 @@ found:
 	if (regulator == NULL) {
 		regulator = ERR_PTR(-ENOMEM);
 		module_put(rdev->owner);
+		goto out;
 	}
 
 	rdev->open_count++;
-- 
1.7.5.4



