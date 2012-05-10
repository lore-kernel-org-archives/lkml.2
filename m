Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754Ab2EJOcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:32:42 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56044 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147Ab2EJOap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:30:45 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 5/9] x86, MCE, AMD: Print decimal thresholding values
Date: Thu, 10 May 2012 16:30:25 +0200
Message-Id: <1336660229-32644-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1336660229-32644-1-git-send-email-bp@amd64.org>
References: <1336660229-32644-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

If one sets the threshold limit, say to 25:

$ echo 25 > machinecheck0/threshold_bank4/misc0/threshold_limit

and then reads it back again, it gives

$ cat machinecheck0/threshold_bank4/misc0/threshold_limit
19

which is actually 0x19 but we don't know that.

Make all output decimal.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index d67c9e56d609..0b1bb0e15881 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -308,7 +308,7 @@ struct threshold_attr {
 #define SHOW_FIELDS(name)						\
 static ssize_t show_ ## name(struct threshold_block *b, char *buf)	\
 {									\
-	return sprintf(buf, "%lx\n", (unsigned long) b->name);		\
+	return sprintf(buf, "%lu\n", (unsigned long) b->name);		\
 }
 SHOW_FIELDS(interrupt_enable)
 SHOW_FIELDS(threshold_limit)
@@ -379,7 +379,7 @@ static ssize_t show_error_count(struct threshold_block *b, char *buf)
 	struct threshold_block_cross_cpu tbcc = { .tb = b, };
 
 	smp_call_function_single(b->cpu, local_error_count_handler, &tbcc, 1);
-	return sprintf(buf, "%lx\n", tbcc.retval);
+	return sprintf(buf, "%lu\n", tbcc.retval);
 }
 
 static ssize_t store_error_count(struct threshold_block *b,
-- 
1.7.9.3.362.g71319

