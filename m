Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1HEOJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 10:09:04 -0400
Received: from relay3.sgi.com ([192.48.152.1]:58266 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751670Ab1HEOJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 10:09:02 -0400
Date: Fri, 5 Aug 2011 09:09:00 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: Remove UV delay in starting slave cpus
Message-ID: <20110805140900.GA6774@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete the 10 msec delay between the INIT and SIPI when starting slave
cpus. I can find no requirement for this delay. BIOS also has similar code
sequences without the delay.

Removing the delay reduces boot time by 40 sec. Every bit helps.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/kernel/apic/x2apic_uv_x.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2011-08-05 08:22:42.511980932 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2011-08-05 08:23:27.488613896 -0500
@@ -207,7 +207,6 @@ static int __cpuinit uv_wakeup_secondary
 	    ((start_rip << UVH_IPI_INT_VECTOR_SHFT) >> 12) |
 	    APIC_DM_INIT;
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
-	mdelay(10);
 
 	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
 	    (phys_apicid << UVH_IPI_INT_APIC_ID_SHFT) |
