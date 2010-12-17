Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0LQAY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:24:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57677 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab0LQAY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:24:56 -0500
Date: Fri, 17 Dec 2010 11:24:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Salikhmetov <alexo@tuxera.com>, Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the vfs-scale tree with the hfsplus
 tree
Message-Id: <20101217112452.956ed361.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

Today's linux-next merge of the vfs-scale tree got a conflict in
fs/hfsplus/hfsplus_fs.h fs/hfsplus/unicode.c between commit
2753cc281c9a0e8a0a45ee2b8110866a9fe63bdd ("hfsplus: over 80 character
lines clean-up") from the hfsplus tree and commits
aafad38382117d0e22b5ae36bc34337fdf20ed74 ("fs: change d_compare for
rcu-walk") and ab7e0cff7d85fd19a0c0740833f947533b851145 ("fs: change
d_hash for rcu-walk") from the vfs-scale tree.

I fixed it up (see below - I used the vfs-scale tree version of the
prototypes in unicode.c) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/hfsplus/hfsplus_fs.h
index f7cbdf8,a5308f4..0000000
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@@ -418,17 -375,16 +418,20 @@@ extern u16 hfsplus_decompose_table[]
  extern u16 hfsplus_compose_table[];
  
  /* unicode.c */
 -int hfsplus_strcasecmp(const struct hfsplus_unistr *, const struct hfsplus_unistr *);
 -int hfsplus_strcmp(const struct hfsplus_unistr *, const struct hfsplus_unistr *);
 -int hfsplus_uni2asc(struct super_block *, const struct hfsplus_unistr *, char *, int *);
 -int hfsplus_asc2uni(struct super_block *, struct hfsplus_unistr *, const char *, int);
 +int hfsplus_strcasecmp(const struct hfsplus_unistr *,
 +		const struct hfsplus_unistr *);
 +int hfsplus_strcmp(const struct hfsplus_unistr *,
 +		const struct hfsplus_unistr *);
 +int hfsplus_uni2asc(struct super_block *,
 +		const struct hfsplus_unistr *, char *, int *);
 +int hfsplus_asc2uni(struct super_block *,
 +		struct hfsplus_unistr *, const char *, int);
- int hfsplus_hash_dentry(struct dentry *dentry, struct qstr *str);
- int hfsplus_compare_dentry(struct dentry *dentry,
- 		struct qstr *s1, struct qstr *s2);
+ int hfsplus_hash_dentry(const struct dentry *dentry, const struct inode *inode,
+ 		struct qstr *str);
+ int hfsplus_compare_dentry(const struct dentry *parent,
+ 		const struct inode *pinode,
+ 		const struct dentry *dentry, const struct inode *inode,
+ 		unsigned int len, const char *str, const struct qstr *name);
  
  /* wrapper.c */
  int hfsplus_read_wrapper(struct super_block *);
