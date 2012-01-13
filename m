Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab2AMRG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 12:06:56 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57437 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab2AMRGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 12:06:53 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, htejun@gmail.com,
        david.henningsson@canonical.com, smcnam@gmail.com,
        gmane@colin.guthr.ie, jamescaldwell1@gmail.com,
        s.maddox@lantizia.me.uk, mszeredi@suse.cz
Subject: [PATCH 0/2] cuse: implement mmap/munmap
Date: Fri, 13 Jan 2012 18:06:37 +0100
Message-Id: <1326474399-27278-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches implement mmap support for CUSE (character device in userspace).

The immediate application for this is to get old games requiring OSS/mmap
support to work with OSS Proxy, written by Tejun.  So firstly this is a call for
testers; please try this out and report any problems.

Three pieces are needed:

kernel:
  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-next

fuse:
  git://fuse.git.sourceforge.net/gitroot/fuse/fuse master

osspd:
  git://fuse.git.sourceforge.net/gitroot/fuse/osspd master


Comments about the interface and implementation in general (not related to OSS
proxy) are very welcome as well.

Thanks,
Miklos

---
Miklos Szeredi (1):
      fuse: create fuse_conn_operations

Tejun Heo (1):
      cuse: implement memory mapping

---
 fs/fuse/cuse.c       |  426 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/fuse/dev.c        |  155 ++-----------------
 fs/fuse/fuse_i.h     |   35 ++++-
 fs/fuse/inode.c      |  167 +++++++++++++++++++-
 include/linux/fuse.h |   25 +++
 5 files changed, 656 insertions(+), 152 deletions(-)
