Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab0LGAfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 19:35:41 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:56465 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab0LGAfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 19:35:40 -0500
Date: Mon, 6 Dec 2010 17:35:39 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: linux-kernel@vger.kernel.org
cc: linux-omap@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] MFD: TWL/TPS: fix twl_probe section mismatch warning in
 mfd/twl-core.c
Message-ID: <alpine.DEB.2.00.1012061734590.13430@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix the following section mismatch warning when building omap2plus_defconfig:

WARNING: vmlinux.o(.data+0x47d7c): Section mismatch in reference from the variable twl_driver to the function .init.text:twl_probe()

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/twl-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 35275ba..615cf38 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -969,7 +969,7 @@ static int twl_remove(struct i2c_client *client)
 }
 
 /* NOTE:  this driver only handles a single twl4030/tps659x0 chip */
-static int __init
+static int
 twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	int				status;
-- 
1.7.2.3

