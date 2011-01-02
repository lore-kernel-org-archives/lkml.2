Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1ABIB6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:01:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:34999 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1ABHWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jan Sembera <jsembera@suse.cz>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Al Viro <viro@zeniv.linux.org.uk>, Richard Henderson <rth@twiddle.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 071/260] binfmt_misc: fix binfmt_misc priority
Date: Sun,  2 Jan 2011 02:16:07 -0500
Message-Id: <1293952756-15010-72-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:24.0961 (UTC) FILETIME=[A9E2D510:01CBAA4D]
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
Cc: Richard Henderson <rth@twiddle.net
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/binfmt_misc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index c4e8353..42b60b0 100644
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
-- 
1.7.3.3

