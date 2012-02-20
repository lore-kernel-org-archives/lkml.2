Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab2BTQ3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:29:43 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:50904 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2BTQ3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:29:42 -0500
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-mm@kvack.org, konrad.wilk@oracle.com,
        dan.magenheimer@oracle.com
Subject: [PATCH 2/2] staging: ramster: Dont build ramster when CONFIGFS_FS=m
Date: Mon, 20 Feb 2012 08:29:31 -0800
Message-Id: <1329755371-5444-2-git-send-email-dan.magenheimer@oracle.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1329755371-5444-1-git-send-email-dan.magenheimer@oracle.com>
References: <1329755371-5444-1-git-send-email-dan.magenheimer@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F4274EE.0007,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramster can't be a module (yet) and depends on CONFIGFS_FS=y, but
allmodconfig builds with CONFIGFS_FS=m, which breaks the build.
And forcing CONFIGFS_FS=y with select breaks the build in other ways.
So just don't build ramster unless CONFIGFS_FS=y.

Also, while we're here, add a comment as to why BROKEN is depended.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
---
 drivers/staging/ramster/Kconfig |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ramster/Kconfig b/drivers/staging/ramster/Kconfig
index b045704..8b57b87 100644
--- a/drivers/staging/ramster/Kconfig
+++ b/drivers/staging/ramster/Kconfig
@@ -1,6 +1,10 @@
+# Dependency on CONFIG_BROKEN is because there is a commit dependency
+# on a cleancache naming change to be submitted by Konrad Wilk
+# a39c00ded70339603ffe1b0ffdf3ade85bcf009a "Merge branch 'stable/cleancache.v13'
+# into linux-next.  Once this commit is present, BROKEN can be removed
 config RAMSTER
 	bool "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
-	depends on (CLEANCACHE || FRONTSWAP) && CONFIGFS_FS && !ZCACHE && !XVMALLOC && !HIGHMEM && BROKEN
+	depends on (CLEANCACHE || FRONTSWAP) && CONFIGFS_FS=y && !ZCACHE && !XVMALLOC && !HIGHMEM && BROKEN
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	default n
-- 
1.7.1

