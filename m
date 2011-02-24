Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab1BXHUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 02:20:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34470 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559Ab1BXHUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 02:20:09 -0500
Date: Thu, 24 Feb 2011 07:20:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs fix
Message-ID: <20110224072008.GY22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Fix for very unpleasant braino in do_umount(); the effect was
that if umount(name, MNT_EXPIRE) failed with -EBUSY it left the kernel
with doubly-taken vfsmount_lock.  The next attempt to mount or umount
something would deadlock, of course...  Please, pull from

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
J. R. Okajima (1):
      Unlock vfsmount_lock in do_umount

Diffstat:
 fs/namespace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

