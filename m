Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2L1UAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:00:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54870 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754192Ab2L1TQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:50 -0500
Message-Id: <20121228190333.385175939@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:46 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kees Cook <keescook@chromium.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 016/173] use clamp_t in UNAME26 fix
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


