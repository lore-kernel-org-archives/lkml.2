Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab0ESBma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:42:30 -0400
Received: from mail.windriver.com ([147.11.1.11]:41224 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935Ab0ESBkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:22 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 06/25] kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
Date: Tue, 18 May 2010 20:39:16 -0500
Message-Id: <1274233175-3675-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:45.0813 (UTC) FILETIME=[29421450:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new debug core api requires all architectures that use to debug
core to implement a function to set the program counter.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Sonic Zhang <sonic.zhang@analog.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/kgdb.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
index 2c501ce..7367aea 100644
--- a/arch/blackfin/kernel/kgdb.c
+++ b/arch/blackfin/kernel/kgdb.c
@@ -439,6 +439,11 @@ int kgdb_validate_break_address(unsigned long addr)
 	return -EFAULT;
 }
 
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+{
+	regs->retx = ip;
+}
+
 int kgdb_arch_init(void)
 {
 	kgdb_single_step = 0;
-- 
1.6.3.3

