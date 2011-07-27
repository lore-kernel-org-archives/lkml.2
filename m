Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab1G0Vsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:35829 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549Ab1G0Vso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900663"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: hirofumi@mail.parknet.co.jp, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [45/99] fat: Fix corrupt inode flags when remove ATTR_SYS flag
Message-Id: <20110727214844.229AD2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit 1adffbae22332bb558c2a29de19d9aca391869f6 upstream.

We are clearly missing '~' in fat_ioctl_set_attributes().

Reported-by: Dmitry Dmitriev <dimondmm@yandex.ru>
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/fat/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/fs/fat/file.c
===================================================================
--- linux-2.6.35.y.orig/fs/fat/file.c
+++ linux-2.6.35.y/fs/fat/file.c
@@ -102,7 +102,7 @@ static int fat_ioctl_set_attributes(stru
 		if (attr & ATTR_SYS)
 			inode->i_flags |= S_IMMUTABLE;
 		else
-			inode->i_flags &= S_IMMUTABLE;
+			inode->i_flags &= ~S_IMMUTABLE;
 	}
 
 	fat_save_attrs(inode, attr);
