Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab2CUWES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:04:18 -0400
Received: from broadrack.ru ([195.178.208.66]:38480 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751150Ab2CUWEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:04:16 -0400
Date: Thu, 22 Mar 2012 02:04:15 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [take 3] pohmelfs: call for inclusion
Message-ID: <20120321220415.GA22315@ioremap.net>
References: <20120316121829.GA12685@ioremap.net>
 <1331904553.5406.34.camel@joe2Laptop>
 <20120316134314.GA19342@ioremap.net>
 <1331907127.5406.48.camel@joe2Laptop>
 <20120321202702.GA16713@ioremap.net>
 <CA+55aFwm+wfMDFwpcngKwrQEeh53JpsDXr9CPU6Xf0mfGvJHKg@mail.gmail.com>
 <20120321211835.GQ6589@ZenIV.linux.org.uk>
 <20120321213704.GB16713@ioremap.net>
 <20120321215432.GR6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321215432.GR6589@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 09:54:32PM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> IDGI.  Again, you are getting different strings for different processes,
> so that one inside a chroot generates shorter pathnames.  I'm not asking
> about races with rename() et.al. - it's obviously racy, but that's a

http_compat ugly mount options forbids rename
It cuts fair amount of functionality present for 'normal' pohmelfs

> separate problem.  Details, please - as far as I can tell, that code
> looks like a reimplementation of dentry_path() in a curiously broken
> way; what demands that particular breakage?  Again, the question of
> pathname stability, uniqueness, etc. is a separate story; why this specific
> weirdness?  Note that you are passing a to d_path() a vfsmount/dentry
> pair that violates all kinds of assertions - dentry->d_sb != mnt->mnt_sb
> more often than not, to start with.

Details are pretty simple - we want to allow external applications to
get to filesystem and grab data via single requests, since it is
stateless and can not hold dentry structure. They do not connect to
server which runs on top of filesystem, but insted directly to storage,
which hosts raw data.

Applications know they uploadede data via /whatever/path/was/to/the/file
And they want to get that data from server via single 'get'. Obviously
they can not store mapping from all filenames to inode number, and they
can not request dozen of directory lookups, since it takes time and has
to maintain state.

When object was written via remounted path, then it is a problem for
those who made a setup - this ugly hack only 'works' in specially
crafted environment, which provides its pros and requires fair price of
cons.

Generic POHMELFS does not require this compatibility mode.

-- 
	Evgeniy Polyakov
