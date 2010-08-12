Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836Ab0HLT1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:27:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47395 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab0HLT1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:27:21 -0400
Date: Thu, 12 Aug 2010 12:26:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] optprobes: fix kconfig depends/selects
Message-Id: <20100812122641.fe88e846.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

KALLSYMS and KALLSYMS_ALL depend on DEBUG_KERNEL, so add that dependency.
KALLSYMS_ALL depends on KALLSYMS, so select both of them, not just KALLSYMS_ALL.

warning: (OPTPROBES && KPROBES && HAVE_OPTPROBES && !PREEMPT || MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI || UBIFS_FS_DEBUG && MISC_FILESYSTEMS && UBIFS_FS || LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc:	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc:	"David S. Miller" <davem@davemloft.net>
Cc:	Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 arch/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20100810.orig/arch/Kconfig
+++ linux-next-20100810/arch/Kconfig
@@ -45,6 +45,8 @@ config OPTPROBES
 	def_bool y
 	depends on KPROBES && HAVE_OPTPROBES
 	depends on !PREEMPT
+	depends on DEBUG_KERNEL
+	select KALLSYMS
 	select KALLSYMS_ALL
 
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
