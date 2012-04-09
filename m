Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2DIRvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:51:09 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23516 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab2DIRvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:51:07 -0400
Subject: [PATCH 0/4] IPC: message queue checkpoint/restore - requested updates
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, dhowells@redhat.com, arnd@arndb.de,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org,
        criu@openvz.org, mtk.manpages@gmail.com
Date: Mon, 09 Apr 2012 21:50:43 +0400
Message-ID: <20120409174135.7456.14077.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set updates IPC checkpoint/restore support according to discussion
of previous patch set named "IPC: message queue checkpoint support".
What has been changed:
1) MSG_STEAL was replaced by MSG_PEEK_ALL (as suggested by Michael Kerrisk)
2) All checkpoint/restore code has been put under CONFIG_CHECKPOINT_RESTORE
define.
3) Added return of ENOSYS in case of sys_msgrcv was called with MSG_PEEK_ALL
flag, but kernel was compiled without checkpoint/restore support.
4) Test for support of SYSV IPC message queues checkpoint/restore added to the
series. Test file: msgque.c

Michael, please, tell me, what I have to do (or provide) to update man page
accordingly.

The following series consists of:

---

Stanislav Kinsbursky (4):
      ipc: rename obfuscating MSG_STEAL flag into MSG_PEEK_ALL
      ipc: move all checkpoint-restore code under appropriate define
      ipc: handle MSG_PEEK_ALL flag if CONFIG_CHECKPOINT_RESTORE is dropped
      test: IPC message queue migration test


 include/linux/msg.h |    2 -
 ipc/compat.c        |   16 ++++-
 ipc/msg.c           |   27 +++++++--
 msgque.c            |  151 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 185 insertions(+), 11 deletions(-)
 create mode 100644 msgque.c

