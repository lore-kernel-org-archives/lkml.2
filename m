Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab0KLTLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 14:11:06 -0500
Received: from duck.dooz.org ([194.146.227.125]:37090 "EHLO duck.dooz.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab0KLTLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 14:11:03 -0500
X-Greylist: delayed 1978 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Nov 2010 14:11:03 EST
From: =?UTF-8?q?Lo=C3=AFc=20Minier?= <loic.minier@linaro.org>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lukas Czerner <lczerner@redhat.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Lo=C3=AFc=20Minier?= <loic.minier@linaro.org>
Subject: [PATCH] Fix userspace build of linux/fs.h
Date: Fri, 12 Nov 2010 19:37:38 +0100
Message-Id: <1289587058-3493-1-git-send-email-loic.minier@linaro.org>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dpkg uses fiemap but didn't particularly need to include stdint.h so
far.  Since 367a51a33902 ("fs: Add FITRIM ioctl"), build of linux/fs.h
failed in dpkg with:
In file included from ../../src/filesdb.c:27:0:
/usr/include/linux/fs.h:37:2: error: expected specifier-qualifier-list before 'uint64_t'

Use exportable type __u64 to avoid the dependency on stdint.h.

b31d42a5af18 fixed only the kernel build by including linux/types.h, but
this also fixed "make headers_check", so don't revert it.

Signed-off-by: Loïc Minier <loic.minier@linaro.org>
Tested-by: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Lukas Czerner <lczerner@redhat.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Theodore Ts'o <tytso@mit.edu>
---
 include/linux/fs.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 334d68a..c734e64 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -34,9 +34,9 @@
 #define SEEK_MAX	SEEK_END
 
 struct fstrim_range {
-	uint64_t start;
-	uint64_t len;
-	uint64_t minlen;
+	__u64 start;
+	__u64 len;
+	__u64 minlen;
 };
 
 /* And dynamically-tunable limits and defaults: */
-- 
1.7.2.3

