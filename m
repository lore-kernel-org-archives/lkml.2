Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab1AJTwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:52:18 -0500
Received: from relay1.sgi.com ([192.48.179.29]:46041 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab1AJTwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:52:16 -0500
Date: Mon, 10 Jan 2011 13:52:11 -0600
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.co
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, UV: Fix APICID shift for westmere processors
Message-ID: <20110110195210.GA18737@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Westmere processors use a different algorithm for
assigning APICIDs on SGI UV systems. The location of the
node number within the apicid is now a function of the
processor type.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2010-12-31 10:53:26.878105424 -0600
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2010-12-31 10:54:45.291099878 -0600
@@ -378,7 +378,7 @@ struct apic __refdata apic_x2apic_uv_x =
 
 static __cpuinit void set_x2apic_extra_bits(int pnode)
 {
-	__get_cpu_var(x2apic_extra_bits) = (pnode << 6);
+	__get_cpu_var(x2apic_extra_bits) = (pnode << uvh_apicid.s.pnode_shift);
 }
 
 /*
