Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934934Ab1ESVgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:36:02 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59113 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934814Ab1ESVeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bY/sbEoUVXX0X4hkz9JWMhDn6eG5bLxO/lDEOih7E+X3/my2Sq6FMgT4LfN7h541et
         bTFAitkTB0P4bt5+RKuZGrzGnQm6OHTF6OCZqkqZ26ID3wTQ1D40Ty1SBfgXzrPJINsB
         7VFEl1pkyPxz60dp0rx741kFmt66Psyu8E2KQ=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 02/23] reimplement alloc_chrdev_region with register_chrdev_ids
Date: Thu, 19 May 2011 15:33:05 -0600
Message-Id: <1305840792-25877-3-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 fs/char_dev.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index 9149b7c..c1bbb9c 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -234,12 +234,8 @@ int __deprecated
 alloc_chrdev_region(dev_t *dev, unsigned baseminor, unsigned count,
 		    const char *name)
 {
-	struct char_device_struct *cd;
-	cd = __register_chrdev_region(0, baseminor, count, name);
-	if (IS_ERR(cd))
-		return PTR_ERR(cd);
-	*dev = MKDEV(cd->major, cd->baseminor);
-	return 0;
+	*dev = MKDEV(0, baseminor);
+	return register_chrdev_ids(dev, count, name);
 }
 
 /**
-- 
1.7.4.4

