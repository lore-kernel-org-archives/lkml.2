Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab0GaQes (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 12:34:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53782 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab0GaQeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 12:34:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MBlqp2CybRi2+PcTFN3cR4y4Sd/5VehlSkwqbgxXf3OrqxcMf/4/JN9p4RDIFHZKr9
         kAoe7MwlzLo5pCIVq+gubIRpfFC8ZmMRr+eASUWqG7dnJPHMay+tixoR3Du5qNnysvNh
         pA23d7+iH6zxlsDSI3cD23uZpWrhfg6JMNofM=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] video: igafb: introduce lost 'return'
Date: Sat, 31 Jul 2010 20:34:30 +0400
Message-Id: <1280594070-3328-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If iga_init() fails, code releases resources and continues to use it.
It seems that after releasing resources 'return' should be.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/video/igafb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/igafb.c b/drivers/video/igafb.c
index 15d2001..c4e6fc0 100644
--- a/drivers/video/igafb.c
+++ b/drivers/video/igafb.c
@@ -531,6 +531,7 @@ int __init igafb_init(void)
 		iounmap(info->screen_base);
 		kfree(par->mmap_map);
 		kfree(info);
+		return -ENODEV;
         }
 
 #ifdef CONFIG_SPARC
-- 
1.7.0.4

