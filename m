Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0HCA2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 20:28:16 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58917 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab0HCA2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 20:28:14 -0400
Subject: Re: VFS scalability git tree
From: john stultz <johnstul@us.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Frank Mayhar <fmayhar@google.com>
In-Reply-To: <20100730091226.GA10437@amd>
References: <20100722190100.GA22269@amd>  <20100730091226.GA10437@amd>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 17:27:59 -0700
Message-ID: <1280795279.3966.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-30 at 19:12 +1000, Nick Piggin wrote:
> On Fri, Jul 23, 2010 at 05:01:00AM +1000, Nick Piggin wrote:
> > I'm pleased to announce I have a git tree up of my vfs scalability work.
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
> > http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git
> > 
> > Branch vfs-scale-working
> > 
> > The really interesting new item is the store-free path walk, (43fe2b)
> > which I've re-introduced. It has had a complete redesign, it has much
> > better performance and scalability in more cases, and is actually sane
> > code now.
> 
> Things are progressing well here with fixes and improvements to the
> branch.

Hey Nick,
	Just another minor compile issue with today's vfs-scale-working branch.

fs/fuse/dir.c:231: error: ‘fuse_dentry_revalidate_rcu’ undeclared here
(not in a function)

>From looking at the vfat and ecryptfs changes in
582c56f032983e9a8e4b4bd6fac58d18811f7d41 it looks like you intended to
add the following? 


diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index f0c2479..9ee4c10 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -154,7 +154,7 @@ u64 fuse_get_attr_version(struct fuse_conn *fc)
  * the lookup once more.  If the lookup results in the same inode,
  * then refresh the attributes, timeouts and mark the dentry valid.
  */
-static int fuse_dentry_revalidate(struct dentry *entry, struct nameidata *nd)
+static int fuse_dentry_revalidate_rcu(struct dentry *entry, struct nameidata *nd)
 {
 	struct inode *inode = entry->d_inode;
 


