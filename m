Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0ICDYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 23:24:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44906 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453Ab0ICDYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 23:24:13 -0400
Date: Fri, 3 Sep 2010 13:24:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Munsie <imunsie@au1.ibm.com>
Subject: linux-next: build failure after merge of the final tree (powerpc
 related)
Message-Id: <20100903132410.ede593ed.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build
(powerpc64 allnoconfig) failed like this:

arch/powerpc/kernel/built-in.o: In function `.sys_call_table':
(.text+0x8d48): undefined reference to `.compat_sys_recv'

Caused by commit 86250b9d12caa1a3dee12a7cf638b7dd70eaadb6 ("powerpc: Wire
up direct socket system calls").

I have applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 3 Sep 2010 13:19:04 +1000
Subject: [PATCH] powerpc: define a compat_sys_recv cond_syscall

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
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


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
