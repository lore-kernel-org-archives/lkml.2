Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab1DYU2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:28:47 -0400
Received: from 1wt.eu ([62.212.114.60]:34679 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932524Ab1DYU2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:28:43 -0400
Message-Id: <20110425200239.422629437@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        Greg KH <greg@kroah.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        debian-release@lists.debian.org,
        "Adam D. Barratt" <adam@adam-barratt.org.uk>,
        paulmck@linux.vnet.ibm.com, mikey@neuling.org,
        benh@kernel.crashing.org, anton@samba.org,
        dann frazier <dannf@dannf.org>, galak@kernel.crashing.org,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 148/173] powerpc: Fix default_machine_crash_shutdown #ifdef botch
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

powerpc: Fix default_machine_crash_shutdown #ifdef botch

Commit: c2be05481f6125254c45b78f334d4dd09c701c82 upstream

crash_kexec_wait_realmode() is defined only if CONFIG_PPC_STD_MMU_64
and CONFIG_SMP, but is called if CONFIG_PPC_STD_MMU_64 even if !CONFIG_SMP.
Fix the conditional compilation around the invocation.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/crash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -447,7 +447,7 @@ void default_machine_crash_shutdown(stru
 	crash_kexec_prepare_cpus(crashing_cpu);
 	cpu_set(crashing_cpu, cpus_in_crash);
 	crash_kexec_stop_spus();
-#ifdef CONFIG_PPC_STD_MMU_64
+#if defined(CONFIG_PPC_STD_MMU_64) && defined(CONFIG_SMP)
 	crash_kexec_wait_realmode(crashing_cpu);
 #endif
 	if (ppc_md.kexec_cpu_down)


