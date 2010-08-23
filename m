Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab0HWOP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 10:15:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab0HWOPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:15:23 -0400
Date: Mon, 23 Aug 2010 16:15:20 +0200
From: Jan Sembera <jsembera@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, ink@jurassic.park.msu.ru
Subject: [PATCH] binfmt_misc: Fix binfmt_misc priority
Message-ID: <20100823141520.GB17894@alaris.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 74641f584da introduced a regression - binfmt_misc is now consulted
after binfmt_elf, which will unfortunately break ia32el. ia32 ELF binaries
on ia64 used to be matched using binfmt_misc and executed using wrapper. As
32bit binaries are now matched by binfmt_elf before bindmt_misc kicks in,
the wrapper is ignored.

The fix increases precedence of binfmt_misc to the original state.

Signed-off-by: Jan Sembera <jsembera@suse.cz>
---
 fs/binfmt_misc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a7528b9..fd0cc0b 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -724,7 +724,7 @@ static int __init init_misc_binfmt(void)
 {
 	int err = register_filesystem(&bm_fs_type);
 	if (!err) {
-		err = register_binfmt(&misc_format);
+		err = insert_binfmt(&misc_format);
 		if (err)
 			unregister_filesystem(&bm_fs_type);
 	}
