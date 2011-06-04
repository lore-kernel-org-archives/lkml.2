Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab1FDHfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 03:35:40 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:32941 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257Ab1FDHfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 03:35:39 -0400
Message-ID: <4DE9E041.5000609@freemail.hu>
Date: Sat, 04 Jun 2011 09:35:29 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Thomas Renninger <trenn@suse.de>, Tejun Heo <tj@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: cleanup "idle=mwait" removal warning message
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 188.143.26.94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Cleanup the warning message. This will remove the following warning message
when compiling:

 * arch/x86/kernel/process.c:645:1: warning: unknown escape sequence '\i'

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-3.0-rc1/arch/x86/kernel/process.c.orig	2011-06-03 23:56:51.000000000 +0200
+++ linux-3.0-rc1/arch/x86/kernel/process.c	2011-06-04 07:23:54.000000000 +0200
@@ -642,7 +642,7 @@ static int __init idle_setup(char *str)
 		boot_option_idle_override = IDLE_POLL;
 	} else if (!strcmp(str, "mwait")) {
 		boot_option_idle_override = IDLE_FORCE_MWAIT;
-		WARN_ONCE(1, "\idle=mwait\" will be removed in 2012\"\n");
+		WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012\n");
 	} else if (!strcmp(str, "halt")) {
 		/*
 		 * When the boot option of idle=halt is added, halt is
