Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2DQSBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:01:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48075 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab2DQSBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:01:30 -0400
Date: Tue, 17 Apr 2012 19:01:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs and fs fixes
Message-ID: <20120417180129.GW6589@ZenIV.linux.org.uk>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
 <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 08:01:48AM -0700, Linus Torvalds wrote:
> On Mon, Apr 16, 2012 at 10:25 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > ? ? ? ?A bunch of endianness fixes plus a patch from bfields untangling
> > dependencies between vfs and nfsd trees; in principle, we could keep it
> > in nfsd tree (along with a bunch of followups that definitely belong there),
> > but Miklos' stuff in fs/namei.c steps fairly close to it and overlayfs
> > and unionfs series - even closer, so that would create serious PITA for
> > both, whichever tree it would sit in.
> 
> Why is that double mutex taking in vfs_rename_other() safe from ABBA?
> 
> We aren't guaranteed to hold the s_vfs_rename_mutex, since the parent
> directories may be the same.
> 
> And yes, we hold the i_mutex on that shared parent, but the inodes may
> exist (hardlinked) in another directory, so another rename could be
> doing the i_mutex in the reverse order.
> 
> Maybe there is some reason why that double lock is safe, but I don't
> see it, and I want it clearly documented. So I'm not pulling this.

It isn't.  Hell knows - I wonder if taking s_vfs_rename_mutex in all cases
in lock_rename() would be the right thing to do; it would remove the
problem, but might cost us too much contention...
