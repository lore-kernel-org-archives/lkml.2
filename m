Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab2EZNKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:10:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41366 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab2EZNKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:10:35 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 5/5] pstore/inode: Make pstore_fill_super() static
Date: Sat, 26 May 2012 06:07:53 -0700
Message-Id: <1338037673-19909-5-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120526130650.GA6242@lizard>
References: <20120526130650.GA6242@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason to extern it. The patch fixes the annoying sparse
warning:

CHECK   fs/pstore/inode.c
fs/pstore/inode.c:264:5: warning: symbol 'pstore_fill_super' was not
declared. Should it be static?

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Acked-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 1950788..49b40ea 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -258,7 +258,7 @@ fail:
 	return rc;
 }
 
-int pstore_fill_super(struct super_block *sb, void *data, int silent)
+static int pstore_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *inode;
 
-- 
1.7.9.2

