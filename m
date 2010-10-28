Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab0J1Ojg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:39:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758835Ab0J1Oje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:39:34 -0400
Date: Thu, 28 Oct 2010 16:39:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: -tip: origin tree build failure (was: [GIT PULL] ext4 update for
 2.6.37)
Message-ID: <20101028143924.GA6985@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's -tip fails to build on !CONFIG_BLOCK, due to upstream commit 367a51a ("fs: 
Add FITRIM ioctl"):

 include/linux/fs.h:36: error: expected specifier-qualifier-list before ‘uint64_t’
 include/linux/fs.h:36: error: expected specifier-qualifier-list before ‘uint64_t’
 include/linux/fs.h:36: error: expected specifier-qualifier-list before ‘uint64_t’

The commit adds uint64_t type usage to fs.h, but linux/types.h is not included 
explicitly - it's only included implicitly via linux/blk_types.h, and there only if 
CONFIG_BLOCK is enabled.

Add the explicit #include to fix this.

Ob'grumpy'tester: this commit has a commit date of yesterday, that equals author 
date while author != committer - how is that possible? Also, the commit was merged 
upstream a few hours after that.

Thanks,

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/fs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6ed7ace..1c73b50 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -9,6 +9,7 @@
 #include <linux/limits.h>
 #include <linux/ioctl.h>
 #include <linux/blk_types.h>
+#include <linux/types.h>
 
 /*
  * It's silly to have NR_OPEN bigger than NR_FILE, but you can change
