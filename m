Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab2E3XXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 19:23:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44471 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab2E3XXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 19:23:02 -0400
Date: Wed, 30 May 2012 16:22:50 -0700
From: "tip-bot for zhenzhong.duan" <zhenzhong.duan@oracle.com>
Message-ID: <tip-2da06af8106f8f35318bb084baf8448797ef058a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        zhenzhong.duan@oracle.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zhenzhong.duan@oracle.com, tglx@linutronix.de
In-Reply-To: <4FC5A77F.6060505@oracle.com>
References: <4FC5A77F.6060505@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mtrr:
  Fix a type overflow in range_to_mtrr func
Git-Commit-ID: 2da06af8106f8f35318bb084baf8448797ef058a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 16:22:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2da06af8106f8f35318bb084baf8448797ef058a
Gitweb:     http://git.kernel.org/tip/2da06af8106f8f35318bb084baf8448797ef058a
Author:     zhenzhong.duan <zhenzhong.duan@oracle.com>
AuthorDate: Wed, 30 May 2012 12:52:15 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 30 May 2012 14:37:00 -0700

x86, mtrr: Fix a type overflow in range_to_mtrr func

When boot on sun G5+ with 4T mem, see an overflow in mtrr cleanup as below.

*BAD*gran_size: 2G      chunk_size: 2G  num_reg: 10     lose cover RAM:
-18014398505283592M

This is because 1<<31 sign extended. Use an unsigned long constant to
fix it.  Useful for mem larger than or equal to 4T.

-v2: Use 64bit constant instead of explicit type conversion as suggested
by Yinghai. Description updated too.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Link: http://lkml.kernel.org/r/4FC5A77F.6060505@oracle.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index ac140c7..bdda2e6 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -266,7 +266,7 @@ range_to_mtrr(unsigned int reg, unsigned long range_startk,
 		if (align > max_align)
 			align = max_align;
 
-		sizek = 1 << align;
+		sizek = 1UL << align;
 		if (debug_print) {
 			char start_factor = 'K', size_factor = 'K';
 			unsigned long start_base, size_base;
