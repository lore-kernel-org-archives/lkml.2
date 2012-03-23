Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab2CWQlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 12:41:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51847 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab2CWQlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 12:41:22 -0400
MIME-Version: 1.0
Message-ID: <2d2c494d-64e3-4968-a406-a8ede7eb39bb@default>
Date: Fri, 23 Mar 2012 09:40:15 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Konrad Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-mm@kvack.org
Subject: [GIT PULL] staging: ramster: unbreak my heart
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F6CA7AD.0083,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg  --

The just-merged ramster staging driver was dependent on a cleanup patch in
cleancache, so was marked CONFIG_BROKEN until that patch could be
merged.  That cleancache patch is now merged (and the correct SHA of the
cleancache patch is 3167760f83899ccda312b9ad9306ec9e5dda06d4 rather than
the one shown in the comment removed in the patch below).

So remove the CONFIG_BROKEN now and the comment that is no longer true...

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

diff --git a/drivers/staging/ramster/Kconfig b/drivers/staging/ramster/Kconfig
index 8b57b87..4af1f8d 100644
--- a/drivers/staging/ramster/Kconfig
+++ b/drivers/staging/ramster/Kconfig
@@ -1,10 +1,6 @@
-# Dependency on CONFIG_BROKEN is because there is a commit dependency
-# on a cleancache naming change to be submitted by Konrad Wilk
-# a39c00ded70339603ffe1b0ffdf3ade85bcf009a "Merge branch 'stable/cleancache.v13'
-# into linux-next.  Once this commit is present, BROKEN can be removed
 config RAMSTER
 	bool "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
-	depends on (CLEANCACHE || FRONTSWAP) && CONFIGFS_FS=y && !ZCACHE && !XVMALLOC && !HIGHMEM && BROKEN
+	depends on (CLEANCACHE || FRONTSWAP) && CONFIGFS_FS=y && !ZCACHE && !XVMALLOC && !HIGHMEM
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	default n
