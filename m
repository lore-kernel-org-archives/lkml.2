Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934193Ab1ESXhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:37:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:58886 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934143Ab1ESXhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:37:31 -0400
Date: Thu, 19 May 2011 23:37:09 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-i878c8a0e0g0ep4v7i6vxnhz@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] core_kernel_data(): Fix architectures that do not define _sdata
Git-Commit-ID: c5fc472171ec4f96d06d1ac039d88f9b89bb95db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 May 2011 23:37:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5fc472171ec4f96d06d1ac039d88f9b89bb95db
Gitweb:     http://git.kernel.org/tip/c5fc472171ec4f96d06d1ac039d88f9b89bb95db
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 20 May 2011 01:22:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 May 2011 01:27:16 +0200

core_kernel_data(): Fix architectures that do not define _sdata

Some architectures such as Alpha do not define _sdata but _data:

  kernel/built-in.o: In function `core_kernel_data':
  kernel/extable.c:77: undefined reference to `_sdata'

So expand the scope of the data range to the text addresses too,
this might be more correct anyway because this way we can
cover readonly variables as well.

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-i878c8a0e0g0ep4v7i6vxnhz@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/extable.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index c2d625f..d44aac0 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -74,7 +74,7 @@ int core_kernel_text(unsigned long addr)
 
 int core_kernel_data(unsigned long addr)
 {
-	if (addr >= (unsigned long)_sdata &&
+	if (addr >= (unsigned long)_stext &&
 	    addr < (unsigned long)_edata)
 		return 1;
 	return 0;
