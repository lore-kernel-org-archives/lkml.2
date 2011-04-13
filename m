Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932964Ab1DMQNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:13:34 -0400
Received: from kroah.org ([198.145.64.141]:53014 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867Ab1DMQN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:48 2011
Message-Id: <20110413161048.418764968@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:10:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        debian-release@lists.debian.org,
        "Adam D. Barratt" <adam@adam-barratt.org.uk>,
        paulmck@linux.vnet.ibm.com, mikey@neuling.org,
        benh@kernel.crashing.org, anton@samba.org,
        dann frazier <dannf@dannf.org>, galak@kernel.crashing.org,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [56/71] powerpc: Fix default_machine_crash_shutdown #ifdef botch
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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


