Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab0IHVK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:10:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39608 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab0IHVKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=a/k0afFndWyG+R9V7WW49w7EGMBNwFTa6Le77MwSvlaFRM/LKae6MnuYivCue+wugC
         tOZNFE2tQwFbqXo5lzhqjn810ae9u6kq+ve37OJ+XgaEla0GUjBz9GHP0bFybnvFL4Ch
         RL64anIMIC0u08bF4vAewVmlCOEGwJIU2twt0=
From: Nikitas Angelinas <nikitasangelinas@gmail.com>
To: kyle@mcmartin.ca, deller@gmx.de, jejb@parisc-linux.org
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nikitas Angelinas <nikitasangelinas@gmail.com>
Subject: [PATCH 2/8] arch/parisc/include/asm: use ARRAY_SIZE macro in mmzone.h
Date: Wed,  8 Sep 2010 22:11:13 +0100
Message-Id: <1283980273-4880-1-git-send-email-nikitasangelinas@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
References: <1283979457-4649-1-git-send-email-nikitasangelinas@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace sizeof(pfnnid_map) / sizeof(pfnnid_map[0]) with
ARRAY_SIZE(pfnnid_map) in mmzone.h

Signed-off-by: Nikitas Angelinas <nikitasangelinas@gmail.com>
---
 arch/parisc/include/asm/mmzone.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/include/asm/mmzone.h b/arch/parisc/include/asm/mmzone.h
index 9608d2c..85b23b6 100644
--- a/arch/parisc/include/asm/mmzone.h
+++ b/arch/parisc/include/asm/mmzone.h
@@ -3,6 +3,8 @@
 
 #ifdef CONFIG_DISCONTIGMEM
 
+#include <linux/kernel.h>
+
 #define MAX_PHYSMEM_RANGES 8 /* Fix the size for now (current known max is 3) */
 extern int npmem_ranges;
 
@@ -51,7 +53,7 @@ static inline int pfn_to_nid(unsigned long pfn)
 		return 0;
 
 	i = pfn >> PFNNID_SHIFT;
-	BUG_ON(i >= sizeof(pfnnid_map) / sizeof(pfnnid_map[0]));
+	BUG_ON(i >= ARRAY_SIZE(pfnnid_map));
 	r = pfnnid_map[i];
 	BUG_ON(r == 0xff);
 
-- 
1.7.2.3

