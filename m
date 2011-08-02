Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1HBGHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 02:07:22 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:44245 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab1HBGHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 02:07:17 -0400
From: Mathias Krause <minipli@googlemail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] ext4: use kzalloc in ext4_kzalloc()
Date: Tue,  2 Aug 2011 08:07:15 +0200
Message-Id: <1312265235-19978-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1312204398-12460-2-git-send-email-tytso@mit.edu>
References: <1312204398-12460-2-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9933fc0i (ext4: introduce ext4_kvmalloc(), ext4_kzalloc(), and
ext4_kvfree()) intruduced wrappers around k*alloc/vmalloc but introduced
a typo for ext4_kzalloc() by not using kzalloc() but kmalloc().

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e2d88ba..4687fea 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -124,7 +124,7 @@ void *ext4_kvzalloc(size_t size, gfp_t flags)
 {
 	void *ret;
 
-	ret = kmalloc(size, flags);
+	ret = kzalloc(size, flags);
 	if (!ret)
 		ret = __vmalloc(size, flags | __GFP_ZERO, PAGE_KERNEL);
 	return ret;
-- 
1.5.6.5

