Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab2BLJnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 04:43:32 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34444 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2BLJnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 04:43:31 -0500
Message-ID: <1329039802.10760.0.camel@phoenix>
Subject: [PATCH] mfd: Fix kcalloc parameters swapped
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>
Date: Sun, 12 Feb 2012 17:43:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first parameter should be "number of elements" and the second parameter
should be "element size".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/mfd-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 0f59228..9fc05b9 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -162,7 +162,7 @@ int mfd_add_devices(struct device *parent, int id,
 	atomic_t *cnts;
 
 	/* initialize reference counting for all cells */
-	cnts = kcalloc(sizeof(*cnts), n_devs, GFP_KERNEL);
+	cnts = kcalloc(n_devs, sizeof(*cnts), GFP_KERNEL);
 	if (!cnts)
 		return -ENOMEM;
 
-- 
1.7.5.4



