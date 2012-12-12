Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab2LLAdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:33:06 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:56741 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab2LLAc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:32:59 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>,
        paul.gortmaker@windriver.com, gregkh@suse.de
Subject: [PATCH 3/5] c2port: fix return value check in duramar2150_c2port_init().
Date: Wed, 12 Dec 2012 01:24:52 +0100
Message-Id: <1355271894-5284-4-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355271894-5284-1-git-send-email-tipecaml@gmail.com>
References: <1355271894-5284-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The c2port_device_register() function returns ERR_PTR() and never returns NULL,
so the NULL check should be replaced by a call to IS_ERR().

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/misc/c2port/c2port-duramar2150.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/c2port/c2port-duramar2150.c b/drivers/misc/c2port/c2port-duramar2150.c
index 5484301..2742e60 100644
--- a/drivers/misc/c2port/c2port-duramar2150.c
+++ b/drivers/misc/c2port/c2port-duramar2150.c
@@ -129,7 +129,7 @@ static int __init duramar2150_c2port_init(void)
 
 	duramar2150_c2port_dev = c2port_device_register("uc",
 					&duramar2150_c2port_ops, NULL);
-	if (!duramar2150_c2port_dev) {
+	if (IS_ERR(duramar2150_c2port_dev)) {
 		ret = -ENODEV;
 		goto free_region;
 	}
-- 
1.7.10.4

