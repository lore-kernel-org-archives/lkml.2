Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279Ab1ALJbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 04:31:04 -0500
Received: from sirius.lasnet.de ([78.47.116.19]:41899 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291Ab1ALJbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 04:31:01 -0500
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Date: Wed, 12 Jan 2011 10:30:42 +0100
Message-Id: <1294824642-19458-1-git-send-email-stefan@datenfreihafen.org>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <4D2CE678.10607@garzik.org>
References: <4D2CE678.10607@garzik.org>
Subject: [PATCH] fs/btrfs: Fix build of ctree
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   CC [M]  fs/btrfs/ctree.o
In file included from fs/btrfs/ctree.c:21:0:
fs/btrfs/ctree.h:1003:17: error: field <91>super_kobj<92> has incomplete type
fs/btrfs/ctree.h:1074:17: error: field <91>root_kobj<92> has incomplete type
make[2]: *** [fs/btrfs/ctree.o] Error 1
make[1]: *** [fs/btrfs] Error 2
make: *** [fs] Error 2

We need to include kobject.h here.

Reported-by: Jeff Garzik <jeff@garzik.org>
Fix-suggested-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
---
 fs/btrfs/ctree.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a142d20..b875d44 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -27,6 +27,7 @@
 #include <linux/backing-dev.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
+#include <linux/kobject.h>
 #include <asm/kmap_types.h>
 #include "extent_io.h"
 #include "extent_map.h"
-- 
1.7.2.3

