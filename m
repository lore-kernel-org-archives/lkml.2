Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005Ab1CCXH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 18:07:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37144 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758833Ab1CCXH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 18:07:26 -0500
Date: Thu, 3 Mar 2011 23:07:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] st_nlink after rmdir() and rename()
Message-ID: <20110303230723.GR22723@ZenIV.linux.org.uk>
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
 <AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
 <20110303060352.GK22723@ZenIV.linux.org.uk>
 <AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
 <87tyfk7x0c.fsf@devron.myhome.or.jp>
 <AANLkTinJPQtcBQsBd+OmioywcxSgzWXFgqMBSrfx8e6D@mail.gmail.com>
 <87lj0v9984.fsf@devron.myhome.or.jp>
 <AANLkTinSiD3YakBTNfYXrE12YDsDREHX3GzLzCncduTV@mail.gmail.com>
 <20110303225702.GQ22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303225702.GQ22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 10:57:02PM +0000, Al Viro wrote:
> 	* inotify is broken for filesystems that don't get you zero ->i_nlink
> when the last dentry pointing to doomed inode is dropped.  Regardless of what
> you get in fstat().  Excusable for remote fs, but not nice for local ones.
> I'd *LOVE* to get rid of inotife/dnotify/etc., but it's probably not feasible
> now.
> 	* NFS is not hard to handle, actually, especially for directories.
> Regular files may be trickier, but then we have many places in that area
> where NFS is not quite POSIX-compliant, to put it mildly.

To clarify: I don't particulary _care_ if NFS breaks something like inotify,
as long as it can't be used to do nasty things to kernel itself.  And I'm
not at all sure if I care about st_nlink there at all, directory or
non-directory.  Again, NFS has enough weirdness wrt opened-but-unlinked
files anyway and will remain weird by design.
