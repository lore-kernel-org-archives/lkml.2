Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab1GHAD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 20:03:57 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:51396 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1GHAD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 20:03:56 -0400
Subject: [PATCH] xtensa: prevent arbitrary read in ptrace
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: chris@zankel.net
Cc: linux-kernel@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jul 2011 20:03:54 -0400
Message-ID: <1310083434.2139.4.camel@anubis>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent an arbitrary kernel read. Check the user pointer with
access_ok() before copying data in.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: stable@kernel.org
---
 arch/xtensa/kernel/ptrace.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index c72c947..ddce75e 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -147,6 +147,9 @@ int ptrace_setxregs(struct task_struct *child, void __user *uregs)
 	elf_xtregs_t *xtregs = uregs;
 	int ret = 0;
 
+	if (!access_ok(VERIFY_READ, uregs, sizeof(elf_xtregs_t)))
+		return -EIO;
+
 #if XTENSA_HAVE_COPROCESSORS
 	/* Flush all coprocessors before we overwrite them. */
 	coprocessor_flush_all(ti);


