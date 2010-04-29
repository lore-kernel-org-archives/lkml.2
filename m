Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab0D3Quc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:50:32 -0400
Received: from mfbichi12.ns.itscom.net ([219.110.2.190]:51714 "EHLO
	mfbichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757639Ab0D3Qu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:50:26 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 16/35] union-mount: Writable overlays/union mounts documentation
To: Valerie Aurora <vaurora@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100428201908.GC16691@shell>
References: <1271372682-21225-9-git-send-email-vaurora@redhat.com> <1271372682-21225-10-git-send-email-vaurora@redhat.com> <1271372682-21225-11-git-send-email-vaurora@redhat.com> <1271372682-21225-12-git-send-email-vaurora@redhat.com> <1271372682-21225-13-git-send-email-vaurora@redhat.com> <1271372682-21225-14-git-send-email-vaurora@redhat.com> <1271372682-21225-15-git-send-email-vaurora@redhat.com> <1271372682-21225-16-git-send-email-vaurora@redhat.com> <1271372682-21225-17-git-send-email-vaurora@redhat.com> <E1O4GKw-000257-Hh@pomaz-ex.szeredi.hu> <20100428201908.GC16691@shell>
Date: Fri, 30 Apr 2010 01:10:16 +0900
Message-ID: <3051.1272557416@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Valerie Aurora:
> One of the major difficulties that arises even when doing unioning at
> the VFS level is keeping around the parent's path in order to do the
> copyup later on.  Take a look at the code pattern in the "union-mount:
> Implement union-aware syscall()" series of patches.  That's the
> prettiest and most efficient version I could come up with, after two
> other implementations, and it's in the VFS, at the vfs_foo_syscall()
> level.  I don't even know how I would start if I had to wait until the
> file system op is called.

I agree that is prettiest, and copup at open for write makes it easier.
But some applications issue mmap(MAP_PRIVATE) after open(O_RDWR), for
example modprobe(8). In this case, every kernel module will be copied-up
and it must be a waste of time and space. And I guess this is one reason
why other implementation took the approach of copyup at write.
At the same time, I guess this issue may be less important since other
parts are pretty enough.


J. R. Okajima
