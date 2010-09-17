Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab0IQHFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 03:05:25 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:37067 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab0IQHFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 03:05:23 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: define a compat_sys_recv cond_syscall
Date: Fri, 17 Sep 2010 17:05:03 +1000
Message-Id: <1284707103-4097-1-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100903132410.ede593ed.sfr@canb.auug.org.au>
References: <20100903132410.ede593ed.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

Since compat_sys_recv is an optionl syscall if the kernel is compiled
without networking we need a cond_syscall defined for it since it is now
wired up directly on PowerPC.

Other architectures that wire up the socket calls directly as syscalls
do not run into this issue either because they don't have to deal with
the 32bit compat versions of the syscalls or just don't wire up that
particular compat syscall directly.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 kernel/sys_ni.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index bad369e..c782fe9 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -50,6 +50,7 @@ cond_syscall(compat_sys_sendmsg);
 cond_syscall(sys_recvmsg);
 cond_syscall(sys_recvmmsg);
 cond_syscall(compat_sys_recvmsg);
+cond_syscall(compat_sys_recv);
 cond_syscall(compat_sys_recvfrom);
 cond_syscall(compat_sys_recvmmsg);
 cond_syscall(sys_socketcall);
-- 
1.7.1

