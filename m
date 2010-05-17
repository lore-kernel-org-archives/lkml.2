Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab0EQTzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:55:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab0EQTze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:55:34 -0400
Date: Mon, 17 May 2010 15:55:07 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 16/35] union-mount: Writable overlays/union mounts documentation
Message-ID: <20100517195506.GC18568@shell>
References: <1271372682-21225-13-git-send-email-vaurora@redhat.com> <1271372682-21225-14-git-send-email-vaurora@redhat.com> <1271372682-21225-15-git-send-email-vaurora@redhat.com> <1271372682-21225-16-git-send-email-vaurora@redhat.com> <1271372682-21225-17-git-send-email-vaurora@redhat.com> <E1O4GKw-000257-Hh@pomaz-ex.szeredi.hu> <20100428201908.GC16691@shell> <E1O7Q7n-0002KC-Tm@pomaz-ex.szeredi.hu> <20100429202012.GA6539@shell> <E1OBSYC-0004oQ-U4@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OBSYC-0004oQ-U4@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 02:57:36PM +0200, Miklos Szeredi wrote:
> On Thu, 29 Apr 2010, Valerie Aurora wrote:
> > On Thu, Apr 29, 2010 at 11:33:39AM +0200, Miklos Szeredi wrote:
> > > On Wed, 28 Apr 2010, Valerie Aurora wrote:
> > > > I went down this road initially (do most of the unioning in a file
> > > > system) and spent a couple of months on it.  But I always ended up
> > > > having to do some level of copy-around and redirection similar to that
> > > > in unionfs.
> > > 
> > > I haven't looked at unionfs in a long time.  Can you say something
> > > more specific about what these problems were?
> > 
> > Sure.  The short version is that unionfs has to allocate another copy
> > of each file system structure - inode, etc. - and then keep an array
> > of the matching structures from each of the file system layers.
> 
> Let's not over-generalize the problem.  Current implementation has the
> following properties:
> 
>  a) one read-only layer and one read-write layer
>  b) for each non-directory only one of the layers is relevant
>  c) for directories both layers may be relevant
>  d) no need to go from a lower dentry or inode to an upper dentry/inode
> 
> >  Each
> > unionfs file system op copies data up and down between the unionfs
> > structures and the underlying structures, and then calls the lower
> > file system op as necessary.  Often it has to duplicate code from the
> > VFS before calling the lower file system ops.
> 
> Yep, and that can be fixed by adding better helpers to the VFS which
> do all the locking magic, etc, and are supplied with a "struct path"
> instead of a "char *".

Hm, I am thinking about your ideas.  Al did a code review a couple of
weeks ago and pointed out ways to eliminate about a third of the code
and push another good chunk down into the file system implementation.
Let me get the new version out and then we can look at pushing what's
left into VFS helper functions.

Thanks,

-VAL
