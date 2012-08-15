Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2HOQYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:24:48 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:3555 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab2HOQYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:24:46 -0400
Subject: [RFC PATCH 0/5] net: socket bind to file descriptor introduced
To: tglx@linutronix.de, mingo@redhat.com, davem@davemloft.net, hpa@zytor.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: thierry.reding@avionic-design.de, bfields@redhat.com,
        eric.dumazet@gmail.com, xemul@parallels.com, neilb@suse.de,
        netdev@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, viro@zeniv.linux.org.uk,
        gorcunov@openvz.org, akpm@linux-foundation.org,
        tim.c.chen@linux.intel.com, devel@openvz.org, ebiederm@xmission.com
Date: Wed, 15 Aug 2012 20:21:56 +0400
Message-ID: <20120815161141.7598.16682.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces new socket operation and new system call:
sys_fbind(), which allows to bind socket to opened file.
File to bind to can be created by sys_mknod(S_IFSOCK) and opened by
open(O_PATH).

This system call is especially required for UNIX sockets, which has name
lenght limitation.

The following series implements...

---

Stanislav Kinsbursky (5):
      net: cleanup unix_bind() a little
      net: split unix_bind()
      net: new protocol operation fbind() introduced
      net: fbind() for unix sockets protocol operations introduced
      syscall: sys_fbind() introduced


 arch/x86/syscalls/syscall_32.tbl |    1 
 arch/x86/syscalls/syscall_64.tbl |    1 
 include/linux/net.h              |    2 +
 include/linux/syscalls.h         |    1 
 kernel/sys_ni.c                  |    3 +
 net/socket.c                     |   25 +++++++
 net/unix/af_unix.c               |  136 ++++++++++++++++++++++++++++++--------
 7 files changed, 140 insertions(+), 29 deletions(-)


