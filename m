Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab1CIE53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 23:57:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55343 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab1CIE51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 23:57:27 -0500
Date: Wed, 9 Mar 2011 04:57:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more vfs fixes
Message-ID: <20110309045725.GA22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Several fixes for Nick's RCU stuff; open() without O_CREAT
can be tricked into creating files, ->d_compare() in /proc/sys is trying
and failing to be RCU-safe (strictly speaking not a regression, but only
because it will be kicked out of RCU mode by ->permission() refusing
to accept IPERM_FLAG_RCU) and spurious errors in open() and vfs_path_lookup()
since we forget to set nd->inode on the LOOKUP_REVAL attempt.  More fixes
tomorrow...  Please, pull from

git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (3):
      minimal fix for do_filp_open() race
      unfuck proc_sysctl ->d_compare()
      nd->inode is not set on the second attempt in path_walk()

Diffstat:
 fs/namei.c             |   14 +++++++++++---
 fs/proc/inode.c        |    8 ++++++--
 fs/proc/proc_sysctl.c  |    7 +++++--
 include/linux/sysctl.h |   14 ++++++++++----
 kernel/sysctl.c        |   15 ++++++++++-----
 5 files changed, 42 insertions(+), 16 deletions(-)

