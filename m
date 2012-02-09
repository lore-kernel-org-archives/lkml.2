Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab2BISBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 13:01:49 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:42560 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab2BISBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 13:01:46 -0500
Subject: [PATCH 0/5] IPC: checkpoint/restore in userspace enhancements
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        eparis@parisplace.org, sds@tycho.nsa.gov
Date: Thu, 09 Feb 2012 22:01:16 +0400
Message-ID: <20120209175043.24392.62810.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set aimed to provide additional functionality for all IPC objects,
which is required for migration these objects by user-space checkpoint/restore
utils.
The main problem here was impossibility to set up object id. This patch set
solves the problem in two steps:
1) Makes it possible to create new object (shared memory, semaphores set or
messages queue) with ID, equal to passed key.
2) Makes it possible to change existent object key.

The following series consists of:

---

Stanislav Kinsbursky (5):
      ipc: "use key as id" functionality for resource get system call introduced
      ipc: segment key change helper introduced
      ipc: add new SHM_SET command for sys_shmctl() call
      ipc: add new MSG_SET command for sys_msgctl() call
      ipc: add new SEM_SET command for sys_semctl() call


 include/linux/ipc.h        |    1 +
 include/linux/msg.h        |    1 +
 include/linux/sem.h        |    1 +
 include/linux/shm.h        |    1 +
 ipc/compat.c               |    9 +++++++
 ipc/msg.c                  |   14 +++++++++-
 ipc/sem.c                  |   11 +++++++-
 ipc/shm.c                  |   14 +++++++++-
 ipc/util.c                 |   59 +++++++++++++++++++++++++++++++++++++++++---
 ipc/util.h                 |    3 ++
 security/selinux/hooks.c   |    3 ++
 security/smack/smack_lsm.c |    3 ++
 12 files changed, 110 insertions(+), 10 deletions(-)

