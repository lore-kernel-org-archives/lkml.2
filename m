Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2HSC6O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 22:58:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:52526 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab2HSC52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422079"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 63/74] Kbuild, lto: Print correct info messages for vmlinux link
Date: Sat, 18 Aug 2012 19:56:59 -0700
Message-Id: <1345345030-22211-64-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With LTO the tmp_vmlinux builds can take very long. Have own messages
to print so that it's clear what's going on. Previously the vmlinux
link would really happen during "LD init/built-in.o"

Also print separate messages for all the vmlinux link steps.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/link-vmlinux.sh |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 4629038..a05c49c 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -176,10 +176,12 @@ if [ -n "${CONFIG_KALLSYMS}" ]; then
 	kallsyms_vmlinux=.tmp_vmlinux2
 
 	# step 1
+	info LDFINAL .tmp_vmlinux1
 	vmlinux_link "" .tmp_vmlinux1
 	kallsyms .tmp_vmlinux1 .tmp_kallsyms1.o
 
 	# step 2
+	info LDFINAL .tmp_vmlinux2
 	vmlinux_link .tmp_kallsyms1.o .tmp_vmlinux2
 	kallsyms .tmp_vmlinux2 .tmp_kallsyms2.o
 
-- 
1.7.7.6

