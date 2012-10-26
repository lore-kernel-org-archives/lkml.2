Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2JZLKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:10:09 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:28211 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2JZLKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:10:07 -0400
Subject: [RFC PATCH 0/5] IPC: CRIU enhancements update
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Larry.Finger@lwfinger.net, mitsuo.hayasaka.hu@hitachi.com,
        nhorman@tuxdriver.com, linux-doc@vger.kernel.org,
        catalin.marinas@arm.com, xemul@parallels.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, dhowells@redhat.com,
        ebiederm@xmission.com, rob@landley.net, dan@mindstab.net,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, devel@openvz.org,
        mtk.manpages@gmail.com
Date: Fri, 26 Oct 2012 15:05:38 +0400
Message-ID: <20121026110103.17494.28182.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is aimed to fix some errors in previously commited "[RFC PATCH
v8 0/5] IPC: checkpoint/restore in userspace enhancements" patch set.

Is particular it:
1) wraps new sysctl in CONFIG_CHECKPOINT_RESTORE macro and updates
documentation
2) fixes self-test to work with new sysctls.
3) cleanup do_msgrcv() to make it looks less ugly aroung MSG_COPY feature.

The following series implements...

---

Stanislav Kinsbursky (5):
      ipc: wrap new sysctls for CRIU inside CONFIG_CHECKPOINT_RESTORE
      ipc: remove redundant MSG_COPY check
      test: IPC message queue copy feature test update
      Documentation: update sysctl/kernel.txt
      ipc: cleanup do_msgrcv() aroung MSG_COPY feature


 Documentation/sysctl/kernel.txt      |   19 ++++++++
 include/linux/msg.h                  |    3 +
 ipc/compat.c                         |    3 +
 ipc/ipc_sysctl.c                     |    4 ++
 ipc/msg.c                            |   84 ++++++++++++++++++++--------------
 ipc/util.c                           |    2 -
 tools/testing/selftests/ipc/msgque.c |   83 ++++++++++++++++++++--------------
 7 files changed, 126 insertions(+), 72 deletions(-)


