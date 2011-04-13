Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab1DMQNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:13:37 -0400
Received: from kroah.org ([198.145.64.141]:52992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932630Ab1DMQN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:48 2011
Message-Id: <20110413161048.320480107@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:10:18 -0700
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
Subject: [55/71] powerpc/kexec: Add ifdef CONFIG_PPC_STD_MMU_64 to PPC64 code
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

powerpc/kexec: Add ifdef CONFIG_PPC_STD_MMU_64 to PPC64 code

This patch introduces PPC64 specific #ifdef bits from the upstream
commit: b3df895aebe091b1657a42a8c859bd49fc96646b.

Reported-and-tested-by: dann frazier <dannf@dannf.org>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/crash.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -163,6 +163,7 @@ static void crash_kexec_prepare_cpus(int
 }
 
 /* wait for all the CPUs to hit real mode but timeout if they don't come in */
+#ifdef CONFIG_PPC_STD_MMU_64
 static void crash_kexec_wait_realmode(int cpu)
 {
 	unsigned int msecs;
@@ -187,6 +188,7 @@ static void crash_kexec_wait_realmode(in
 	}
 	mb();
 }
+#endif
 
 /*
  * This function will be called by secondary cpus or by kexec cpu
@@ -445,7 +447,9 @@ void default_machine_crash_shutdown(stru
 	crash_kexec_prepare_cpus(crashing_cpu);
 	cpu_set(crashing_cpu, cpus_in_crash);
 	crash_kexec_stop_spus();
+#ifdef CONFIG_PPC_STD_MMU_64
 	crash_kexec_wait_realmode(crashing_cpu);
+#endif
 	if (ppc_md.kexec_cpu_down)
 		ppc_md.kexec_cpu_down(1, 0);
 }


