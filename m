Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab1DOU3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:29:20 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36424 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab1DOU3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:29:19 -0400
Date: Fri, 15 Apr 2011 13:29:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org, paulus@samba.org,
        kexec@lists.infradead.org, ebiederm@xmission.com
Subject: [PATCH] powerpc: Fix kexec-related UP build error
Message-ID: <20110415202916.GA6758@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The following patch fixes a UP build problem for kexec() on powerpc.
When the crash_kexec_wait_realmode() function was added, it was
placed in only two of the three required locations.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

The function crash_kexec_wait_realmode() is defined only if SMP, but is
called in UP builds.  Create an empty function to keep the compiler happy
in UP builds.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index 3d3d416..6f964ef 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -251,6 +251,10 @@ static void crash_kexec_prepare_cpus(int cpu)
 #endif
 }
 
+static void crash_kexec_wait_realmode(int cpu)
+{
+}
+
 void crash_kexec_secondary(struct pt_regs *regs)
 {
 	cpus_in_sr = CPU_MASK_NONE;
