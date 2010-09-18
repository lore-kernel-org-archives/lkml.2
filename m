Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab0IRTwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:52:09 -0400
Received: from kroah.org ([198.145.64.141]:51413 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346Ab0IRTBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:44 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:57 2010
Message-Id: <20100918185957.354994023@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Sembera <jsembera@suse.cz>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Al Viro <viro@ZenIV.linux.org.uk>, Richard Henderson <rth@twiddle.net>
Subject: [053/123] binfmt_misc: fix binfmt_misc priority
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=binfmt_misc-fix-binfmt_misc-priority.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Sembera <jsembera@suse.cz>

commit ee3aebdd8f5f8eac41c25c80ceee3d728f920f3b upstream.

Commit 74641f584da ("alpha: binfmt_aout fix") (May 2009) introduced a
regression - binfmt_misc is now consulted after binfmt_elf, which will
unfortunately break ia32el.  ia32 ELF binaries on ia64 used to be matched
using binfmt_misc and executed using wrapper.  As 32bit binaries are now
matched by binfmt_elf before bindmt_misc kicks in, the wrapper is ignored.

The fix increases precedence of binfmt_misc to the original state.

Signed-off-by: Jan Sembera <jsembera@suse.cz>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/binfmt_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -723,7 +723,7 @@ static int __init init_misc_binfmt(void)
 {
 	int err = register_filesystem(&bm_fs_type);
 	if (!err) {
-		err = register_binfmt(&misc_format);
+		err = insert_binfmt(&misc_format);
 		if (err)
 			unregister_filesystem(&bm_fs_type);
 	}


