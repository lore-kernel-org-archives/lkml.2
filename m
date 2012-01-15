Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab2AOM4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 07:56:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52283 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab2AOM4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 07:56:17 -0500
Subject: Re: [PATCH] fs/ubifs: fix dbg_{jnlk, tnck, mntk} not defined in
 debug.h if debug is disabled
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sun, 15 Jan 2012 14:56:14 +0200
In-Reply-To: <1326583683-17066-1-git-send-email-asmadeus@codewreck.org>
References: <1326583683-17066-1-git-send-email-asmadeus@codewreck.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1326632175.2201.7.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-01-15 at 00:28 +0100, Dominique Martinet wrote:
> ---
>  fs/ubifs/debug.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)

Hi, thanks. I've changes the subject and commit message to make
it clear that this is a build fix. I've also changed the patch
a bit to preserve alignment. And pushed to ubifs-2.6.git.

I'll send a pull request to Linus with this fix soon.

Notice, you did not put Signed-off-by - which is fine with me but
generally people add it.

Artem.


commit e234b5f2079414b3d772286e3ee00e7bbf6da833
Author: Dominique Martinet <asmadeus@codewreck.org>
Date:   Sun Jan 15 00:28:03 2012 +0100

    UBIFS: fix non-debug configuration build
    
    Fix a brown paperbag bug introduced by me in the previous commit. I was
    in hurry and forgot about the non-debug case completely.
    
    Artem: amend the commit message and tweak the patch to preserve alignment.
           This made the patch a bit less readable, though.
    
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>

diff --git a/fs/ubifs/debug.h b/fs/ubifs/debug.h
index 307ab1d..ad1a6fe 100644
--- a/fs/ubifs/debug.h
+++ b/fs/ubifs/debug.h
@@ -347,20 +347,23 @@ void dbg_debugfs_exit_fs(struct ubifs_info *c);
 #define dbg_dump_stack()
 #define ubifs_assert_cmt_locked(c)
 
-#define dbg_msg(fmt, ...)   ubifs_dbg_msg(fmt, ##__VA_ARGS__)
-#define dbg_gen(fmt, ...)   ubifs_dbg_msg(fmt, ##__VA_ARGS__)
-#define dbg_jnl(fmt, ...)   ubifs_dbg_msg(fmt, ##__VA_ARGS__)
-#define dbg_tnc(fmt, ...)   ubifs_dbg_msg(fmt, ##__VA_ARGS__)
-#define dbg_lp(fmt, ...)    ubifs_dbg_msg(fmt, ##__VA_ARGS__)
-#define dbg_find(fmt, ...)  ubifs_dbg_msg(fmt, ##__VA_ARGS__)
-#define dbg_mnt(fmt, ...)   ubifs_dbg_msg(fmt, ##__VA_ARGS__)
-#define dbg_io(fmt, ...)    ubifs_dbg_msg(fmt, ##__VA_ARGS__)
-#define dbg_cmt(fmt, ...)   ubifs_dbg_msg(fmt, ##__VA_ARGS__)
-#define dbg_budg(fmt, ...)  ubifs_dbg_msg(fmt, ##__VA_ARGS__)
-#define dbg_log(fmt, ...)   ubifs_dbg_msg(fmt, ##__VA_ARGS__)
-#define dbg_gc(fmt, ...)    ubifs_dbg_msg(fmt, ##__VA_ARGS__)
-#define dbg_scan(fmt, ...)  ubifs_dbg_msg(fmt, ##__VA_ARGS__)
-#define dbg_rcvry(fmt, ...) ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_msg(fmt, ...)       ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_gen(fmt, ...)       ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_jnl(fmt, ...)       ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_jnlk(key, fmt, ...) ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_tnc(fmt, ...)       ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_tnck(key, fmt, ...) ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_lp(fmt, ...)        ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_find(fmt, ...)      ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_mnt(fmt, ...)       ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_mntk(key, fmt, ...) ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_io(fmt, ...)        ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_cmt(fmt, ...)       ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_budg(fmt, ...)      ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_log(fmt, ...)       ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_gc(fmt, ...)        ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_scan(fmt, ...)      ubifs_dbg_msg(fmt, ##__VA_ARGS__)
+#define dbg_rcvry(fmt, ...)     ubifs_dbg_msg(fmt, ##__VA_ARGS__)
 
 static inline int ubifs_debugging_init(struct ubifs_info *c)      { return 0; }
 static inline void ubifs_debugging_exit(struct ubifs_info *c)     { return; }


