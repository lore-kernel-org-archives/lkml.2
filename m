Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab0HNArx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 20:47:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61933 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab0HNArw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 20:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=E9OLbhC25T8JKOty8kW0ZIMMWPZ2jUNVVIAZ1dVRoPAHWVjli2wl99QB6mNN9TvNgR
         SP0tTPnYJ1aA6Po9ZFldo2YE62pYLEIHLhlUWFRijKhRNWM2hvwNI2KW0kLn/tv+PG/r
         D59xT9WhmWg1eeJ63zRLUQSFPThLsqzoEd+Dc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, John Kacur <jkacur@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Joern Engel <joern@logfs.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] Bkl ioctl removal for 2.6.36
Date: Sat, 14 Aug 2010 02:47:48 +0200
Message-Id: <1281746868-6731-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the bkl/ioctl branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	bkl/ioctl

This removes struct file_operations:ioctl() as there are no more users
of it.

That branch is based on a very recent version of your tree and not
2.6.35 because I needed every pending pushdowns to be upstream before
applying the final removal (and test it with allyesconfig).

Thanks,
	Frederic
---

Arnd Bergmann (2):
      logfs: kill BKL
      bkl: Remove locked .ioctl file operation

Frederic Weisbecker (1):
      v4l: Remove reference to bkl ioctl in compat ioctl handling


 Documentation/filesystems/Locking         |    8 +-------
 Documentation/filesystems/vfs.txt         |    6 +-----
 drivers/media/video/v4l2-compat-ioctl32.c |    7 +------
 fs/bad_inode.c                            |    7 -------
 fs/compat_ioctl.c                         |    3 +--
 fs/ioctl.c                                |   18 ++++--------------
 fs/logfs/dir.c                            |    2 +-
 fs/logfs/file.c                           |    6 +++---
 fs/logfs/logfs.h                          |    3 +--
 fs/proc/inode.c                           |   17 ++++-------------
 include/linux/fs.h                        |    5 ++---
 11 files changed, 19 insertions(+), 63 deletions(-)
