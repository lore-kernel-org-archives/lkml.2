Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab1HNUuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 16:50:11 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40926 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621Ab1HNUuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 16:50:10 -0400
From: Sergei Trofimovich <slyfox@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        J Freyensee <james_p_freyensee@linux.intel.com>,
        Jeremy Rocher <rocher.jeremy@gmail.com>
Subject: [PATCH] pti: fix build failure
Date: Sun, 14 Aug 2011 23:52:51 +0300
Message-Id: <1313355177-12605-1-git-send-email-slyfox@gentoo.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found on allmodconfig build (ARCH=alpha)

    drivers/misc/pti.c: In function 'get_id':
    drivers/misc/pti.c:249: error: implicit declaration of function 'kmalloc'
    drivers/misc/pti.c: In function 'pti_char_write':
    drivers/misc/pti.c:658: error: implicit declaration of function 'copy_from_user'

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: Jeremy Rocher <rocher.jeremy@gmail.com>
---
 drivers/misc/pti.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 8653bd0..06df187 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -33,6 +33,8 @@
 #include <linux/mutex.h>
 #include <linux/miscdevice.h>
 #include <linux/pti.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
 
 #define DRIVERNAME		"pti"
 #define PCINAME			"pciPTI"
-- 
1.7.3.4

