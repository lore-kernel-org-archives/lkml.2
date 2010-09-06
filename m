Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0IFTK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 15:10:28 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47248 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0IFTKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 15:10:22 -0400
To: NeilBrown <neilb@suse.de>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, haveblue@us.ibm.com,
        linux-kernel@vger.kernel.org
In-reply-to: <20100906005029.20775.70918.stgit@localhost.localdomain> (message
	from NeilBrown on Mon, 06 Sep 2010 10:50:29 +1000)
Subject: Re: [PATCH 09/10] VFS: Remove read-only checks from dentry_permission
References: <20100906004829.20775.68828.stgit@localhost.localdomain> <20100906005029.20775.70918.stgit@localhost.localdomain>
Message-Id: <E1Osh50-0005s0-V7@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 21:10:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Sep 2010, NeilBrown wrote:
> It is not sufficient to depend on the the "filesystem is readonly"
> tests in dentry_permission as it does not check if the vfsmnt is
> readonly.
> All call sites already call mnt_want_write or __mnt_is_readonly which
> includes the test on MS_RDONLY.

Last time I checked I found some holes (in nfsd IIRC).  That was a
long time ago and things may have changed.

That check could be replaced with a

		if (IS_RDONLY(inode) &&
		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
			BUG();

which would catch these cases but only if the superblock was marked
r/o.  Otherwise it's basically impossible to make sure the callers of
the VFS play by the rules.  That was one reason I advocated a
path_... interface for the VFS instead of the current dentry based
one, but Al didn't like it.

Thanks,
Miklos
