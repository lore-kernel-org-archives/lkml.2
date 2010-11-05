Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0KELPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 07:15:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab0KELPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 07:15:48 -0400
From: =?UTF-8?q?S=C3=B8ren=20Sandmann=20Pedersen?= <ssp@redhat.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] x86: Eliminate bp argument from the stack tracing routines
Date: Fri,  5 Nov 2010 07:14:33 -0400
Message-Id: <1288955674-2744-1-git-send-email-ssp@redhat.com>
In-Reply-To: <ye8ljj3mlj5.fsf@camel16.daimi.au.dk>
References: <ye8ljj3mlj5.fsf@camel16.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a resurrection of an old patch that I sent about a year ago:

     http://lkml.org/lkml/2009/10/22/192

At the time, I thought the patch broke perf callchains on 64 bit, but
it turns out that those are broken even without this patch. 

I don't know why that is, but I now think the patch is correct and to
blame.

(FWIW, this

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 461a85d..d977d26 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1653,7 +1653,7 @@ static const struct stacktrace_ops backtrace_ops = {
 	.warning_symbol		= backtrace_warning_symbol,
 	.stack			= backtrace_stack,
 	.address		= backtrace_address,
-	.walk_stack		= print_context_stack_bp,
+	.walk_stack		= print_context_stack,
 };

makes it produce correct kernel callchains. And yes, I did compile the
kernel with CONFIG_FRAME_POINTER).


Soren


