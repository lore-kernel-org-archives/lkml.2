Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab2ARFNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 00:13:10 -0500
Received: from trent.utfs.org ([194.246.123.103]:48819 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab2ARFNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 00:13:08 -0500
Date: Tue, 17 Jan 2012 21:13:05 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linuxppc-dev@lists.ozlabs.org
Subject: Re: error: 'cpus_in_crash' defined but not used
In-Reply-To: <alpine.DEB.2.01.1201172006310.2895@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1201172104410.2895@trent.utfs.org>
References: <alpine.DEB.2.01.1201172006310.2895@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012 at 20:13, Christian Kujau wrote:
> 
> compiling today's git (mainline, a25a2b8) on powerpc32 gives:
> 
>   CC      arch/powerpc/kernel/crash.o
> cc1: warnings being treated as errors
> /usr/local/src/linux-2.6-git/arch/powerpc/kernel/crash.c:49: error: 
> ‘cpus_in_crash’ defined but not used
> make[2]: *** [arch/powerpc/kernel/crash.o] Error 1
> make[1]: *** [arch/powerpc/kernel] Error 2
> make: *** [sub-make] Error 2

I could not find cpus_in_crash anywhere in the sourcetree, except for 
arch/powerpc/kernel/crash.c. Moving the definition into the CONFIG_SMP 
ifdef helps on my UP system, of course - not sure about other machines 
though:

diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index 28be345..abef751 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -46,7 +46,6 @@
 
 /* This keeps a track of which one is the crashing cpu. */
 int crashing_cpu = -1;
-static atomic_t cpus_in_crash;
 static int time_to_dump;
 
 #define CRASH_HANDLER_MAX 3
@@ -66,6 +65,7 @@ static int handle_fault(struct pt_regs *regs)
 
 #ifdef CONFIG_SMP
 
+static atomic_t cpus_in_crash;
 void crash_ipi_callback(struct pt_regs *regs)
 {
 	static cpumask_t cpus_state_saved = CPU_MASK_NONE;


Christian.
-- 
BOFH excuse #272:

Netscape has crashed
