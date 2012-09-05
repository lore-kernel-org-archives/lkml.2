Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab2IEK60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:58:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56336 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2IEK6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:58:24 -0400
Date: Wed, 5 Sep 2012 03:58:13 -0700
From: tip-bot for Mathias Krause <minipli@googlemail.com>
Message-ID: <tip-5c7d03e99cb1ed449328ed9fba0c632944d39e7e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        minipli@googlemail.com, suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        minipli@googlemail.com, suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1346621506-30857-6-git-send-email-minipli@googlemail.com>
References: <1346621506-30857-6-git-send-email-minipli@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/fpu/xsave: Keep __user annotation in casts
Git-Commit-ID: 5c7d03e99cb1ed449328ed9fba0c632944d39e7e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 05 Sep 2012 03:58:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c7d03e99cb1ed449328ed9fba0c632944d39e7e
Gitweb:     http://git.kernel.org/tip/5c7d03e99cb1ed449328ed9fba0c632944d39e7e
Author:     Mathias Krause <minipli@googlemail.com>
AuthorDate: Sun, 2 Sep 2012 23:31:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 5 Sep 2012 10:52:25 +0200

x86/fpu/xsave: Keep __user annotation in casts

Don't remove the __user annotation of the fpstate pointer, but
drop the superfluous void * cast instead.

This fixes the following sparse warnings:

  xsave.c:135:15: warning: cast removes address space of expression
  xsave.c:135:15: warning: incorrect type in argument 1 (different address spaces)
  xsave.c:135:15:    expected void const volatile [noderef] <asn:1>*<noident>
  [...]

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1346621506-30857-6-git-send-email-minipli@googlemail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/xsave.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 3d3e207..9e1a8a7 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -132,9 +132,9 @@ int check_for_xstate(struct i387_fxsave_struct __user *buf,
 	    fx_sw_user->xstate_size > fx_sw_user->extended_size)
 		return -EINVAL;
 
-	err = __get_user(magic2, (__u32 *) (((void *)fpstate) +
-					    fx_sw_user->extended_size -
-					    FP_XSTATE_MAGIC2_SIZE));
+	err = __get_user(magic2, (__u32 __user *) (fpstate +
+						   fx_sw_user->extended_size -
+						   FP_XSTATE_MAGIC2_SIZE));
 	if (err)
 		return err;
 	/*
