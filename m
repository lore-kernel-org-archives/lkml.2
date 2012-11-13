Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab2KMIAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:00:40 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:64068 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2KMIAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:00:37 -0500
Date: Tue, 13 Nov 2012 12:00:32 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into
 inotify_inode_mark
Message-ID: <20121113080032.GF6511@moon>
References: <20121112101440.665694060@openvz.org>
 <20121112101845.839702715@openvz.org>
 <20121112165540.2ec39f50.akpm@linux-foundation.org>
 <20121113072057.GC6511@moon>
 <20121112234001.009b2ae3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121112234001.009b2ae3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 11:40:01PM -0800, Andrew Morton wrote:
> On Tue, 13 Nov 2012 11:20:57 +0400 Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > > 
> > > Whoa.  This adds 128+8 bytes to the inotify_inode_mark.  That's a lot of
> > > bloat, and there can be a lot of inotify_inode_mark's in the system?
> > 
> > Yes, that's why it's not turned on by default, only if is c/r turned on.
> > iirc I've been said that usually only about 40 bytes is used (in the tests
> > I met only 8 bytes). Letme re-check all things.
> 
> The question is, how many `struct inotify_inode_mark's are instantiated
> system-wide?  Could be millions?

Well, hard to tell, to be fair. On my testing machine only apache has been
using inotify system as far as I remember, but for sure nothing except memory
limit the number of inotify. But I think if one running machine with millions
of inotify it's rather powerful machine with enough memory.

> Dumb question: do we really need inotify_inode_mark.fhandle at all? 
> What prevents us from assembling this info on demand when ->show_fdinfo() is
> called?

exportfs requires the dentry to be passed as an argument while inotify works
with inodes instead and at moment of show-fdinfo the target dentry might be
already deleted but inode yet present as far as I remember.
