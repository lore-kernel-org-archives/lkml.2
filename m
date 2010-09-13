Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab0IMT4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:56:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:51124 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab0IMT4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:56:01 -0400
Date: Mon, 13 Sep 2010 19:54:47 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        randy.dunlap@oracle.com, davem@davemloft.net,
        anil.s.keshavamurthy@intel.com, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, akpm@linux-foundation.org,
        tglx@linutronix.de, felipe.contreras@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        randy.dunlap@oracle.com, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, akpm@linux-foundation.org,
        tglx@linutronix.de, felipe.contreras@gmail.com, mingo@elte.hu
In-Reply-To: <20100913102541.20260.85700.stgit@ltc236.sdl.hitachi.co.jp>
References: <20100913102541.20260.85700.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes: Fix Kconfig dependency
Message-ID: <tip-05ed160e89baf7f5fb3432d527fec467d2493626@git.kernel.org>
Git-Commit-ID: 05ed160e89baf7f5fb3432d527fec467d2493626
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 13 Sep 2010 19:54:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05ed160e89baf7f5fb3432d527fec467d2493626
Gitweb:     http://git.kernel.org/tip/05ed160e89baf7f5fb3432d527fec467d2493626
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 13 Sep 2010 19:25:41 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 13 Sep 2010 20:41:31 +0200

kprobes: Fix Kconfig dependency

Fix Kconfig dependency among Kprobes, optprobe and kallsyms.

Kprobes uses kallsyms_lookup for finding target function and
checking instruction boundary, thus CONFIG_KPROBES should select
CONFIG_KALLSYMS.

Optprobe is an optional feature which is supported on x86 arch,
and it also uses kallsyms_lookup for checking instructions in
the target function. Since KALLSYMS_ALL just adds symbols of
kernel variables, it doesn't need to select KALLSYMS_ALL.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>,
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: akpm <akpm@linux-foundation.org>
LKML-Reference: <20100913102541.20260.85700.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 4877a8c..fe48fc7 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -32,8 +32,9 @@ config HAVE_OPROFILE
 
 config KPROBES
 	bool "Kprobes"
-	depends on KALLSYMS && MODULES
+	depends on MODULES
 	depends on HAVE_KPROBES
+	select KALLSYMS
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
@@ -45,7 +46,6 @@ config OPTPROBES
 	def_bool y
 	depends on KPROBES && HAVE_OPTPROBES
 	depends on !PREEMPT
-	select KALLSYMS_ALL
 
 config HAVE_EFFICIENT_UNALIGNED_ACCESS
 	bool
