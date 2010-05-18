Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0ERED3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 00:03:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49253 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab0ERED2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 00:03:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=ArlKS55xtQ0QY2eQorv+ULAxzd55xzE0fRzOlTrblh7FUkhkvXtdUp0UU3tbpxp8gl
         NvGXwGNNLDexfZCo+wUZ1woG9hxvNbdZ2UWN0qzfShvklE19uktCdfu8LXxXW41o/Bec
         kw7/8RW+WIEF3eDmPaMLYRHtNg8rPFy8MhadM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Frederic Lassabe <frederic.lassabe@gmail.com>
Subject: [GIT PULL] Procfs bkl removal for 2.6.35
Date: Tue, 18 May 2010 06:03:31 +0200
Message-Id: <1274155411-11588-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the bkl/procfs branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	bkl/procfs

Thanks,
	Frederic
---

Frederic Weisbecker (6):
      procfs: Use generic_file_llseek in /proc/kcore
      procfs: Use generic_file_llseek in /proc/kmsg
      procfs: Use generic_file_llseek in /proc/vmcore
      procfs: Push down the bkl from ioctl
      procfs: Kill the bkl in ioctl
      sunrpc: Include missing smp_lock.h

Arnd Bergmann (1):
      procfs: Kill BKL in llseek on proc base


 drivers/char/i8k.c                  |   21 ++++++++++++++++-----
 drivers/isdn/divert/divert_procfs.c |   18 ++++++++++++++----
 fs/proc/base.c                      |   10 +++++++++-
 fs/proc/inode.c                     |    4 ++--
 fs/proc/kcore.c                     |    1 +
 fs/proc/kmsg.c                      |    1 +
 fs/proc/vmcore.c                    |    1 +
 net/sunrpc/cache.c                  |   15 +++++++++++----
 8 files changed, 55 insertions(+), 16 deletions(-)
