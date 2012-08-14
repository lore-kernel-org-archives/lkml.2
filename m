Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2HNPe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:34:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:60362 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab2HNPeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:34:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,766,1336374000"; 
   d="scan'208";a="200768309"
Date: Tue, 14 Aug 2012 23:34:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, linux-c6x-dev@linux-c6x.org,
        Lennox Wu <lennox.wu@gmail.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH] select GENERIC_ATOMIC64 for c6x/score/unicore32 archs
Message-ID: <20120814153413.GA18601@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I have no compilers for build testing these changes, however the
risk looks low and it's much better than to leave the arch broken,
considering that Eric will do atomic64_t in the core fs/namespace.c code.

CC: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---

Andrew: the arch maintainers have been CCed. Best is the maintainers
respond, test and perhaps take the corresponding change. Let's see how
this will work out..


 arch/c6x/Kconfig       |    1 +
 arch/score/Kconfig     |    1 +
 arch/unicore32/Kconfig |    1 +
 3 files changed, 3 insertions(+)

--- linux.orig/arch/c6x/Kconfig	2012-06-14 22:29:58.187502107 +0800
+++ linux/arch/c6x/Kconfig	2012-08-14 23:23:18.147838692 +0800
@@ -16,6 +16,7 @@ config C6X
 	select OF
 	select OF_EARLY_FLATTREE
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_ATOMIC64
 
 config MMU
 	def_bool n
--- linux.orig/arch/score/Kconfig	2012-06-14 22:29:58.219502109 +0800
+++ linux/arch/score/Kconfig	2012-08-14 23:23:37.691839156 +0800
@@ -10,6 +10,7 @@ config SCORE
        select ARCH_DISCARD_MEMBLOCK
        select GENERIC_CPU_DEVICES
        select GENERIC_CLOCKEVENTS
+       select GENERIC_ATOMIC64
 
 choice
 	prompt "System type"
--- linux.orig/arch/unicore32/Kconfig	2012-07-25 19:09:37.671358715 +0800
+++ linux/arch/unicore32/Kconfig	2012-08-14 23:23:52.351839505 +0800
@@ -14,6 +14,7 @@ config UNICORE32
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_FRAME_POINTERS
 	select GENERIC_IOMAP
+	select GENERIC_ATOMIC64
 	help
 	  UniCore-32 is 32-bit Instruction Set Architecture,
 	  including a series of low-power-consumption RISC chip
