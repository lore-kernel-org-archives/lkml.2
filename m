Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945939Ab2JTBp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:45:57 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42208 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933203Ab2JTBp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:45:56 -0400
Date: Fri, 19 Oct 2012 18:45:53 -0700
From: Kees Cook <keescook@chromium.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] use clamp_t in UNAME26 fix
Message-ID: <20121020014553.GA6785@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The min/max call needed to have explicit types on some architectures
(e.g. mn10300). Use clamp_t instead to avoid the warning.

kernel/sys.c: In function 'override_release':
kernel/sys.c:1287:10: warning: comparison of distinct pointer types lacks a cast [enabled by default]

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 01865c6..e6e0ece 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1284,7 +1284,7 @@ static int override_release(char __user *release, size_t len)
 			rest++;
 		}
 		v = ((LINUX_VERSION_CODE >> 8) & 0xff) + 40;
-		copy = min(sizeof(buf), max_t(size_t, 1, len));
+		copy = clamp_t(size_t, len, 1, sizeof(buf));
 		copy = scnprintf(buf, copy, "2.6.%u%s", v, rest);
 		ret = copy_to_user(release, buf, copy + 1);
 	}
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
