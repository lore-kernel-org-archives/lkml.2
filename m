Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934793Ab0EENPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 09:15:55 -0400
Received: from mail-ew0-f222.google.com ([209.85.219.222]:61180 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934601Ab0EENPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 09:15:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=B6I0X1qG3nL+tIVFv89iLP6Y7WiUv++YVxMcOrAN209POatsKnGFsxYe9AIs4pCJg6
         Wrb8LXNRsy7VfxF65tOC80xiDLe5nrRM1gr2YnS1TlfI+Ht7J/1Fs3K293oig40Xud7c
         KtbmdF9q0xXEuRZYKhVlzgSv5SYCcAImmnZSs=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/6] BKL ioctl pushdown
Date: Wed,  5 May 2010 15:15:33 +0200
Message-Id: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches convert ioctls to unlocked_ioctls by pushing down the bkl into
them. I had to go outside of the files that we agreed on, because logically the
ioctls in each kind of file system belong together.

Frederic and Arnd, you can pull from:
git.kernel.org//pub/scm/linux/kernel/git/jkacur/jk-2.6.git linus-bkl-pushdown

John Kacur (6):
  coda: BKL ioctl pushdown
  coda: Clean-up whitespace problems in pioctl.c
  fat: BKL ioctl pushdown
  ncpfs: BKL ioctl pushdown
  smbfs: BKL ioctl pushdown
  udf: BKL ioctl pushdown

 fs/coda/pioctl.c       |   76 ++++++++++++++++++++++++++----------------------
 fs/fat/dir.c           |   36 +++++++++++++++-------
 fs/fat/fat.h           |    3 +-
 fs/fat/file.c          |   22 ++++++++++----
 fs/ncpfs/dir.c         |    2 +-
 fs/ncpfs/file.c        |    2 +-
 fs/ncpfs/ioctl.c       |   27 ++++++++++-------
 fs/smbfs/dir.c         |    2 +-
 fs/smbfs/file.c        |    2 +-
 fs/smbfs/ioctl.c       |   10 ++++--
 fs/smbfs/proto.h       |    2 +-
 fs/udf/dir.c           |    2 +-
 fs/udf/file.c          |   43 +++++++++++++++++----------
 fs/udf/udfdecl.h       |    3 +-
 include/linux/ncp_fs.h |    2 +-
 15 files changed, 140 insertions(+), 94 deletions(-)

