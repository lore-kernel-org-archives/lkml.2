Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620Ab2KZRLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:11:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47846 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591Ab2KZRKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:10:54 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 176/270] use clamp_t in UNAME26 fix
Date: Mon, 26 Nov 2012 14:57:46 -0200
Message-Id: <1353949160-26803-177-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 31fd84b95eb211d5db460a1dda85e004800a7b52 upstream.

The min/max call needed to have explicit types on some architectures
(e.g. mn10300). Use clamp_t instead to avoid the warning:

  kernel/sys.c: In function 'override_release':
  kernel/sys.c:1287:10: warning: comparison of distinct pointer types lacks a cast [enabled by default]

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 1b66408..b6fe559 100644
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

