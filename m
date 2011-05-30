Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1E3Dr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 23:47:58 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:35082 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab1E3Drz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 23:47:55 -0400
Date: Sun, 29 May 2011 23:47:52 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Len Brown <len.brown@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, stable@kernel.org
Subject: Re: linux-next: build warningiIn Linus' tree
In-reply-to: <20110530114828.8ef6625b.sfr@canb.auug.org.au>
Message-id: <alpine.LFD.2.02.1105292346340.10035@arrandale.kernel.org>
References: <20110530114828.8ef6625b.sfr@canb.auug.org.au>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>
Date: Sun, 29 May 2011 23:38:15 -0400
Subject: [PATCH] x86 idle: fix build warning for WARN_ONCE("idle=mwait")

In 5d4c47e0195b989f284907358bd5c268a44b91c7
"x86 idle: deprecate mwait_idle() and "idle=mwait" cmdline param"...

I fat-fingered the editing when I updated the WARN_ONCE() string:

arch/x86/kernel/process.c: In function 'idle_setup':
arch/x86/kernel/process.c:645:1: warning: unknown escape sequence: '\i'

remove the '\n' while we are here, it works fine without it.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 426a5b6..c54f87d 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -642,7 +642,7 @@ static int __init idle_setup(char *str)
 		boot_option_idle_override = IDLE_POLL;
 	} else if (!strcmp(str, "mwait")) {
 		boot_option_idle_override = IDLE_FORCE_MWAIT;
-		WARN_ONCE(1, "\idle=mwait\" will be removed in 2012\"\n");
+		WARN_ONCE(1, "\"idle=mwait\" will be removed in 2012");
 	} else if (!strcmp(str, "halt")) {
 		/*
 		 * When the boot option of idle=halt is added, halt is
-- 
1.7.4.4


