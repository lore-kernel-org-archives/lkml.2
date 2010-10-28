Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab0J1H4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 03:56:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37938 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144Ab0J1H4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 03:56:40 -0400
Date: Thu, 28 Oct 2010 09:56:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: -tip: origin tree build failure (was: [GIT PULL] ext4 update for
 2.6.37)
Message-ID: <20101028075631.GA7690@elte.hu>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1PBKT9-0004Uk-Sm@tytso-glaptop>
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


hi Ted,

> Theodore Ts'o (18):
>       ext4: rename {exit,init}_ext4_*() to ext4_{exit,init}_*()

Today's -tip fails to build due to upstream commit 5dabfc7 ("ext4: rename 
{exit,init}_ext4_*() to ext4_{exit,init}_*()"), on all[yes/mod]config with 
CONFIG_EXT4_FS_XATTR disabled:

  fs/ext4/super.c:4776: error: implicit declaration of function ‘ext4_init_xattr’

Commit 5dabfc7 renamed init_ext4_xattr to ext4_init_xattr but forgot to update the 
definition in fs/ext4/xattr.h. The patch below fixes it.

Thanks,

	Ingo

Signed-off-by: Ingo Molnar <mingo@elte.hu>

--- linux.orig/fs/ext4/xattr.h
+++ linux/fs/ext4/xattr.h
@@ -122,7 +122,7 @@ ext4_xattr_put_super(struct super_block 
 }
 
 static __init inline int
-init_ext4_xattr(void)
+ext4_init_xattr(void)
 {
 	return 0;
 }

