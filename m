Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab0JTUXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:23:25 -0400
Received: from BERING.ISR.CS.CMU.EDU ([128.2.209.223]:44641 "EHLO
	bering.isr.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab0JTUXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:23:25 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: [RFC][PATCH 0/3] Coda: remove BKL
Date: Wed, 20 Oct 2010 16:23:01 -0400
Message-Id: <1287606184-26889-1-git-send-email-jaharkes@cs.cmu.edu>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following three patches remove the big kernel lock from the Coda
file system kernel module. We initially add a spinlock to protect the
Coda-specific inode data. After this we can push the BKL all the way
down to where the requests are queued for the userspace Coda cache
manager process and finally we replace the remaining BKL uses with a
mutex that protects the upcall queues.

Yoshihisa Abe (3):
      Coda: add spin lock to protect accesses to struct coda_inode_info.
      Coda: push BKL regions into coda_upcall()
      Coda: replace BKL with mutex

 fs/coda/cache.c            |   17 ++++--
 fs/coda/cnode.c            |   19 ++++--
 fs/coda/dir.c              |  158 ++++++++++++++------------------------------
 fs/coda/file.c             |   31 ++++-----
 fs/coda/inode.c            |   57 +++++++++-------
 fs/coda/pioctl.c           |   22 ++-----
 fs/coda/psdev.c            |   30 +++++----
 fs/coda/symlink.c          |    3 -
 fs/coda/upcall.c           |   24 +++++--
 include/linux/coda_fs_i.h  |   13 +++-
 include/linux/coda_linux.h |    6 ++-
 include/linux/coda_psdev.h |    2 +
 12 files changed, 177 insertions(+), 205 deletions(-)

