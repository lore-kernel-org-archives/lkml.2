Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab2AFTTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 14:19:07 -0500
Received: from relay2.sgi.com ([192.48.179.30]:48161 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932638Ab2AFTTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 14:19:06 -0500
Date: Fri, 6 Jan 2012 13:19:00 -0600
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: Update Boot messages for SGI UV2 platform
Message-ID: <20120106191900.GA19772@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SGI UV systems print a message during boot:
	UV: Found <num> blades

Due to packaging changes, the blade count is not accurate for
on the next generation of the platform. This patch corrects the
count.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2012-01-06 13:07:05.000000000 -0600
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2012-01-06 13:08:36.935895457 -0600
@@ -781,7 +781,12 @@ void __init uv_system_init(void)
 	for(i = 0; i < UVH_NODE_PRESENT_TABLE_DEPTH; i++)
 		uv_possible_blades +=
 		  hweight64(uv_read_local_mmr( UVH_NODE_PRESENT_TABLE + i * 8));
-	printk(KERN_DEBUG "UV: Found %d blades\n", uv_num_possible_blades());
+
+	/* uv_num_possible_blades() is really the hub count */
+	printk(KERN_INFO "UV: Found %d blades, %d hubs\n",
+			is_uv1_hub() ? uv_num_possible_blades() :
+			(uv_num_possible_blades() + 1) / 2,
+			uv_num_possible_blades());
 
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
 	uv_blade_info = kzalloc(bytes, GFP_KERNEL);
