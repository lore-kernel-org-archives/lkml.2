Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab1CVSMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:12:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47524 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab1CVSMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:12:48 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de
In-reply-to: <AANLkTikQt9JRp4jx9qcTEr6nKMppA8Gj3=E12aFUGUYs@mail.gmail.com>
	(message from Linus Torvalds on Tue, 22 Mar 2011 10:18:59 -0700)
Subject: Re: [PATCH 1/6 v7] vfs: add i_op->open()
References: <20110322152602.053930811@szeredi.hu> <20110322153014.560003169@szeredi.hu> <AANLkTikQt9JRp4jx9qcTEr6nKMppA8Gj3=E12aFUGUYs@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1Q264S-0001Fy-HU@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 22 Mar 2011 19:12:44 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Mar 2011, Linus Torvalds wrote:
> > +               struct inode *inode = nd->path.dentry->d_inode;
> > +
> > +               if (inode->i_op->open) {
> > +                       int flags = filp->f_flags;
> > +                       put_filp(filp);
> > +                       filp = inode->i_op->open(nd->path.dentry, flags, cred);
> > +               } else {
> > +                       filp = __dentry_open(&nd->path, filp, NULL, cred);
> > +               }
> 
> This seems broken.
> 
> Why don't you just pass in the filp to the ->open routine, and drop
> that "flags" argument. Maybe other filesystems want to use ->open, but
> don't want to put_filp() on the filp we already allocated, only to
> allocate a new one?

Maybe, although I don't see the reason to do that.  Why keep the
original one?  It doesn't contain any information besides the flags
and the dentry/vfsmount.

Thanks,
Miklos
