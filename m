Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0LWL5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:57:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47511 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab0LWL5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:57:36 -0500
Date: Thu, 23 Dec 2010 12:57:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andres Salomon <dilinger@queued.net>, Milton Miller <miltonm@bga.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: OLPC: speed up device tree creation during boot
 (v2)
Message-ID: <20101223115716.GA2108@elte.hu>
References: <20101111214546.4e573cad@queued.net>
 <reply-olpc-3-v2@mdm.bga.com>
 <20101112002704.50c629e2@queued.net>
 <20101114095013.GB24206@elte.hu>
 <4CE0B54E.6000101@zytor.com>
 <20101115070254.GA25243@elte.hu>
 <4CE17133.2050101@zytor.com>
 <20101118083420.GC26398@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118083420.GC26398@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > However, I have to vehemently object to putting them in a wider scope
> > than is otherwise necessary.  I agree that static variables should be
> > used sparsely if at all (there really are vary few uses of them that are
> > valid), but putting them in a larger scope screams "I'm used in more
> > than one function", and that is *not* a good thing.
> 
> That's why we sometimes use the (imperfect) compromise to put them in front of 
> that function, not at the top of the file.
> 
> Look at the general balance of hardship: very little harm is done (it's not a big 
> deal if a variable is only used in a single function) but having it with local 
> variables can be _really_ harmful - for example i overlooked them when i reviewed 
> this patch. I dont like important details obscured - i like them to be apparent. 
> Again, this is something that some people can parse immediately on the visual 
> level - me and many others cannot.

As an addendum, beyond my own bad experience with them, see below a recent upstream 
fix that shows the kinds of problems that overlooked function scope statics can 
cause.

	Ingo

------------->
>From 3cb50ddf97a0a1ca4c68bc12fa1e727a6b45fbf2 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 20 Dec 2010 15:53:18 +0000
Subject: [PATCH] Fix btrfs b0rkage

Buggered-in: 76dda93c6ae2 ("Btrfs: add snapshot/subvolume destroy
ioctl")

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/btrfs/export.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 6f04444..659f532 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -166,7 +166,7 @@ static struct dentry *btrfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
 static struct dentry *btrfs_get_parent(struct dentry *child)
 {
 	struct inode *dir = child->d_inode;
-	static struct dentry *dentry;
+	struct dentry *dentry;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
