Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab0IMKYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:24:37 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:47341 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0IMKYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 06:24:35 -0400
X-AuditID: b753bd60-a7f34ba000000226-28-4c8dfbe0c98f
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -next,-tip ] kprobes: Fix Kconfig dependency
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        akpm <akpm@linux-foundation.org>
Date: Mon, 13 Sep 2010 19:25:41 +0900
Message-ID: <20100913102541.20260.85700.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <4C8DCFAE.4020700@hitachi.com>
References: <4C8DCFAE.4020700@hitachi.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix Kconfig dependency among Kprobes, optprobe and kallsyms.

Kprobes uses kallsyms_lookup for finding target function and checking
instruction boundary, thus CONFIG_KPROBES should select CONFIG_KALLSYMS.

Optprobe is an optional feature which is supported on x86 arch, and
it also uses kallsyms_lookup for checking instructions in the target
function. Since KALLSYMS_ALL just adds symbols of kernel variables,
it doesn't need to select KALLSYMS_ALL.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
Cc: linux-kernel@vger.kernel.org,
Cc: linux-next@vger.kernel.org,
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
Cc: "David S. Miller" <davem@davemloft.net>,
Cc: akpm <akpm@linux-foundation.org>
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

