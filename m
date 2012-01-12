Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab2ALLlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 06:41:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab2ALLll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 06:41:41 -0500
Message-ID: <1326368496.5195.4.camel@tucsk.pomaz.szeredi.hu>
Subject: Re: [git pull] vfs pile 1
From: Miklos Szeredi <mszeredi@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Ted Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Date: Thu, 12 Jan 2012 12:41:36 +0100
In-Reply-To: <20120111161934.GH23916@ZenIV.linux.org.uk>
References: <20120105022318.GG23916@ZenIV.linux.org.uk>
	 <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
	 <20120111115846.GA2646@infradead.org>
	 <1326285382.13736.4.camel@tucsk.pomaz.szeredi.hu>
	 <20120111124001.GA834@infradead.org>
	 <1326287556.13736.12.camel@tucsk.pomaz.szeredi.hu>
	 <20120111152337.GA4589@thunk.org>
	 <20120111161934.GH23916@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 16:19 +0000, Al Viro wrote:

> Looking at the callers, I'm not sure we want that warning in set_nlink()
> at all, rate-limited or not.  Note that it can trigger on the things
> like stale NFS fhandle coming in for something that had been deleted
> a while ago - IOW, it's neither a kernel bug nor fs corruption.
> inc_nlink - sure, that might catch real bugs, drop_nlink - definitely,
> but this...

Patch follows.

Thanks,
Miklos
----

Subject: vfs: remove printk from set_nlink()

From: Miklos Szeredi <mszeredi@suse.cz>

Don't log a message for set_nlink(0).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/inode.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/fs/inode.c
===================================================================
--- linux-2.6.orig/fs/inode.c	2012-01-11 10:55:00.000000000 +0100
+++ linux-2.6/fs/inode.c	2012-01-12 12:32:44.000000000 +0100
@@ -322,9 +322,6 @@ EXPORT_SYMBOL(clear_nlink);
 void set_nlink(struct inode *inode, unsigned int nlink)
 {
 	if (!nlink) {
-		printk_ratelimited(KERN_INFO
-			"set_nlink() clearing i_nlink on %s inode %li\n",
-			inode->i_sb->s_type->name, inode->i_ino);
 		clear_nlink(inode);
 	} else {
 		/* Yes, some filesystems do change nlink from zero to one */


