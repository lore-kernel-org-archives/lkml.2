Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab2DXPON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 11:14:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44772 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab2DXPOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 11:14:11 -0400
From: Gerard Snitselaar <dev@snitselaar.org>
To: sameo@linux.intel.com
Cc: ldewangan@nvidia.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd/tps65910: fix section mismatch in linux-next
Date: Tue, 24 Apr 2012 08:13:55 -0700
Message-Id: <1335280435-2457-1-git-send-email-dev@snitselaar.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tps65910_i2c_probe() calls tps65910_sleepinit() which is annnotated __init.

Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
---
 drivers/mfd/tps65910.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index ae7f47b..c050ae5 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -150,7 +150,7 @@ err_sleep_init:
 }
 
 
-static int tps65910_i2c_probe(struct i2c_client *i2c,
+static int __init tps65910_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
 {
 	struct tps65910 *tps65910;
-- 
1.7.7.6

