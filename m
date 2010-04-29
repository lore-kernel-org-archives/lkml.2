Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902Ab0D3Why (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 18:37:54 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35079 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759891Ab0D3Whl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 18:37:41 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20100428201908.GC16691@shell> (message from Valerie Aurora on
	Wed, 28 Apr 2010 16:19:09 -0400)
Subject: Re: [PATCH 16/35] union-mount: Writable overlays/union mounts documentation
References: <1271372682-21225-9-git-send-email-vaurora@redhat.com> <1271372682-21225-10-git-send-email-vaurora@redhat.com> <1271372682-21225-11-git-send-email-vaurora@redhat.com> <1271372682-21225-12-git-send-email-vaurora@redhat.com> <1271372682-21225-13-git-send-email-vaurora@redhat.com> <1271372682-21225-14-git-send-email-vaurora@redhat.com> <1271372682-21225-15-git-send-email-vaurora@redhat.com> <1271372682-21225-16-git-send-email-vaurora@redhat.com> <1271372682-21225-17-git-send-email-vaurora@redhat.com> <E1O4GKw-000257-Hh@pomaz-ex.szeredi.hu> <20100428201908.GC16691@shell>
Message-Id: <E1O7Q7n-0002KC-Tm@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Apr 2010 11:33:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010, Valerie Aurora wrote:
> I'm sorry I have responded sooner, I've been trying to write a
> detailed useful message and that turns out to be hard.  I'll just
> include a few of the highlights; mainly I want to say that I'd
> rather do it the way you describe but when I tried it ended up even
> uglier than the VFS implementation.
> 
> I went down this road initially (do most of the unioning in a file
> system) and spent a couple of months on it.  But I always ended up
> having to do some level of copy-around and redirection similar to that
> in unionfs.

I haven't looked at unionfs in a long time.  Can you say something
more specific about what these problems were?

> One of the major difficulties that arises even when doing unioning at
> the VFS level is keeping around the parent's path in order to do the
> copyup later on.  Take a look at the code pattern in the "union-mount:
> Implement union-aware syscall()" series of patches.  That's the
> prettiest and most efficient version I could come up with, after two
> other implementations, and it's in the VFS, at the vfs_foo_syscall()
> level.  I don't even know how I would start if I had to wait until the
> file system op is called.

On a high level I don't see a problem, the parent of every dentry can
be found through ->d_parent.

One issue is having to duplicate some locking and other stuff around
vfs_whatever() calls.  But that could be fixed by exporting suitable
helpers from the VFS.

Other than that I don't see any fundamental issues with union
filesystems (except that they seem to grow too many features to be
maintainable).

Thanks,
Miklos
