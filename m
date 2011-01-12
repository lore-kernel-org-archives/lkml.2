Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142Ab1ALFAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 00:00:31 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:45803 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab1ALFAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 00:00:18 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
        David McCullough <davidm@snapgear.com>,
        Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] firmware loader: use vcoalesce for NOMMU
Date: Wed, 12 Jan 2011 00:08:09 -0500
Message-Id: <1294808889-11453-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.rc1
In-Reply-To: <1294808889-11453-1-git-send-email-vapier@gentoo.org>
References: <1294808889-11453-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOMMU parts can't support vmap, so use vcoalesce instead.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/base/firmware_class.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 40af43e..ab1488d 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -248,7 +248,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
 			vunmap(fw_priv->fw->data);
-			fw_priv->fw->data = vmap(fw_priv->pages,
+			fw_priv->fw->data = vcoalesce(fw_priv->pages,
 						 fw_priv->nr_pages,
 						 0, PAGE_KERNEL_RO);
 			if (!fw_priv->fw->data) {
-- 
1.7.4.rc1

