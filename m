Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442Ab2CUVyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:54:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37179 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764Ab2CUVyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:54:38 -0400
Date: Wed, 21 Mar 2012 21:54:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [take 3] pohmelfs: call for inclusion
Message-ID: <20120321215432.GR6589@ZenIV.linux.org.uk>
References: <20120316121829.GA12685@ioremap.net>
 <1331904553.5406.34.camel@joe2Laptop>
 <20120316134314.GA19342@ioremap.net>
 <1331907127.5406.48.camel@joe2Laptop>
 <20120321202702.GA16713@ioremap.net>
 <CA+55aFwm+wfMDFwpcngKwrQEeh53JpsDXr9CPU6Xf0mfGvJHKg@mail.gmail.com>
 <20120321211835.GQ6589@ZenIV.linux.org.uk>
 <20120321213704.GB16713@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321213704.GB16713@ioremap.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 01:37:04AM +0400, Evgeniy Polyakov wrote:
> On Wed, Mar 21, 2012 at 09:18:35PM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> > I think I've asked that question at least 3 times.  Never got anything
> > resembling an answer...  Is that misspelled dentry_path()?  Or is something
> > subtle going on and we really want different strings generated for
> > chrooted processes here?
> 
> This is a special case which does bad things intentionally.
> http-compatibility was added in _this_ POHMELFS on demand from people
> who do want to access files by handle created from whole path. Not name
> or inode number, but whole path, since that's only what is available in
> http (or more generally via rest api)
> 
> It is limited, wrong and error-prone. It does not even support rename
> and hardlinks. But that's what people want.
> When I bind-remount part of the tree, things 'dissapear' from the tree.
> Yes, this is really an uglymoron, but it was created for _some_ limited
> case which rougly work in sandboxed environment only.

IDGI.  Again, you are getting different strings for different processes,
so that one inside a chroot generates shorter pathnames.  I'm not asking
about races with rename() et.al. - it's obviously racy, but that's a
separate problem.  Details, please - as far as I can tell, that code
looks like a reimplementation of dentry_path() in a curiously broken
way; what demands that particular breakage?  Again, the question of
pathname stability, uniqueness, etc. is a separate story; why this specific
weirdness?  Note that you are passing a to d_path() a vfsmount/dentry
pair that violates all kinds of assertions - dentry->d_sb != mnt->mnt_sb
more often than not, to start with.
