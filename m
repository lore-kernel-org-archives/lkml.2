Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab2JXPfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 11:35:54 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:16561 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758577Ab2JXPfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 11:35:51 -0400
Subject: [RFC PATCH v8 0/5] IPC: checkpoint/restore in userspace enhancements
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, xemul@parallels.com,
        catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org,
        cmetcalf@tilera.com, joe.korty@ccur.com, dhowells@redhat.com,
        dledford@redhat.com, viro@zeniv.linux.org.uk,
        kosaki.motohiro@jp.fujitsu.com, linux-api@vger.kernel.org,
        serue@us.ibm.com, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        devel@openvz.org, mtk.manpages@gmail.com
Date: Wed, 24 Oct 2012 19:34:51 +0400
Message-ID: <20121024151555.5642.79086.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v8:
This respin of the patch set was significantly reworked. Most part of new API
was replaced by sysctls (by one per messages, semaphores and shared memory),
allowing to preset desired id for next new IPC object.

This patch set is aimed to provide additional functionality for all IPC
objects, which is required for migration of these objects by user-space
checkpoint/restore utils (CRIU).

The main problem here was impossibility to set up object id. This patch set
solves the problem by adding new sysctls for preset of desired id for new IPC
object.

Another problem was to peek messages from queues without deleting them.
This was achived by introducing of new MSG_COPY flag for sys_msgrcv(). If
MSG_COPY flag is set, then msgtyp is interpreted as message number.

The following series implements...

---

Stanislav Kinsbursky (5):
      ipc: remove forced assignment of selected message
      ipc: add sysctl to specify desired next object id
      ipc: message queue receive cleanup
      ipc: message queue copy feature introduced
      test: IPC message queue copy feture test


 include/linux/ipc_namespace.h        |    1 
 include/linux/msg.h                  |    5 -
 include/uapi/linux/msg.h             |    1 
 ipc/compat.c                         |   45 +++----
 ipc/ipc_sysctl.c                     |   28 ++++
 ipc/msg.c                            |   99 +++++++++++----
 ipc/msgutil.c                        |   38 ++++++
 ipc/util.c                           |   16 ++
 ipc/util.h                           |    2 
 tools/testing/selftests/ipc/Makefile |   25 ++++
 tools/testing/selftests/ipc/msgque.c |  231 ++++++++++++++++++++++++++++++++++
 11 files changed, 432 insertions(+), 59 deletions(-)
 create mode 100644 tools/testing/selftests/ipc/Makefile
 create mode 100644 tools/testing/selftests/ipc/msgque.c

