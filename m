Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935258Ab1ETExj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:53:39 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:38943 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932159Ab1ETExh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:53:37 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 06/12] staging: usbip: stub_main.c: use KMEM_CACHE macro
Date: Thu, 19 May 2011 21:37:00 -0700
Message-Id: <810a17cd0703bc6899a73d83dc30dcfe575ec5e9.1305866084.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305866084.git.mfm@muteddisk.com>
References: <cover.1305866084.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change kmem_cache_create() to the KMEM_CACHE() macro.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/stub_main.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index 53d6977..45a0f5d 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -249,9 +249,8 @@ static int __init usbip_host_init(void)
 {
 	int ret;
 
-	stub_priv_cache = kmem_cache_create("stub_priv",
-					    sizeof(struct stub_priv), 0,
-					    SLAB_HWCACHE_ALIGN, NULL);
+	stub_priv_cache = KMEM_CACHE(stub_priv, SLAB_HWCACHE_ALIGN);
+
 	if (!stub_priv_cache) {
 		pr_err("kmem_cache_create failed\n");
 		return -ENOMEM;
-- 
1.7.5.1

