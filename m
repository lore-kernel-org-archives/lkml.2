Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab1CCEmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 23:42:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53350 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab1CCEmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 23:42:45 -0500
Date: Thu, 3 Mar 2011 04:42:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] st_nlink after rmdir() and rename()
Message-ID: <20110303044242.GJ22723@ZenIV.linux.org.uk>
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303032454.GI22723@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 03:24:54AM +0000, Al Viro wrote:
> 0 0: ext*, xfs, jfs, reiserfs, ocfs2, gfs2, nilfs, exofs, udf, ubifs,
>      minix, sysv, ufs, msdos, vfat, hfs+
> 0 1: ramfs, shmem, hugetlbfs, jffs2, omfs, hfs[*], apparently nfs as well

> [*] yes, different from hfs+; the code is clearly broken, since it simply
> does unlink() on target, without even verifying that it's empty.  And
> yes, it's trivial fs corruption...

Actually, hfs turns out to be 0 0 as well; it *is* broken (lacks check
for target being empty), but when the target is empty it's doing the
right thing.  jffs2 and ramfs-based ones do 0 1 - confirmed by direct
experiment.
