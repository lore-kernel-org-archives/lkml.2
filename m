Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab1E3JiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 05:38:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42355 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1E3JiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 05:38:11 -0400
From: Borislav Petkov <bp@alien8.de>
To: Len Brown <len.brown@intel.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH] x86 idle: Fix mwait deprecation warning
Date: Mon, 30 May 2011 11:38:06 +0200
Message-Id: <1306748286-24701-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.5.rc1.16.g9db1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix

arch/x86/kernel/process.c:645:1: warning: unknown escape sequence '\i'

due to missing escape backslash.

Cc: Len Brown <len.brown@intel.com>
Cc: stable@kernel.org # .39.x
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 426a5b6..3d83a71 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -642,7 +642,7 @@ static int __init idle_setup(char *str)
 		boot_option_idle_override = IDLE_POLL;
 	} else if (!strcmp(str, "mwait")) {
 		boot_option_idle_override = IDLE_FORCE_MWAIT;
-		WARN_ONCE(1, "\idle=mwait\" will be removed in 2012\"\n");
+		WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012\"\n");
 	} else if (!strcmp(str, "halt")) {
 		/*
 		 * When the boot option of idle=halt is added, halt is
-- 
1.7.5.rc1.16.g9db1

