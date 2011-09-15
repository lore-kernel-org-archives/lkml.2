Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1IOHwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 03:52:46 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49385 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab1IOHwo convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:4:1>);
	Thu, 15 Sep 2011 03:52:44 -0400
Message-Id: <4E71CAE8020000780005635C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 15 Sep 2011 08:52:40 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen/i386: follow-up to "replace order-based range
	 checking of M2P table by linear one"
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The numbers obtained from the hypervisor really can't ever lead to an
overflow here, only the original calculation going through the order
of the range could have. This avoids the (as Jeremy points outs)
somewhat ugly NULL-based calculation here.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/xen/mmu.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- 3.1-rc6/arch/x86/xen/mmu.c
+++ 3.1-rc6-i386-xen-p2m-nr/arch/x86/xen/mmu.c
@@ -1721,10 +1721,8 @@ void __init xen_setup_machphys_mapping(v
 		machine_to_phys_nr = MACH2PHYS_NR_ENTRIES;
 	}
 #ifdef CONFIG_X86_32
-	if ((machine_to_phys_mapping + machine_to_phys_nr)
-	    < machine_to_phys_mapping)
-		machine_to_phys_nr = (unsigned long *)NULL
-				     - machine_to_phys_mapping;
+	WARN_ON((machine_to_phys_mapping + (machine_to_phys_nr - 1))
+		< machine_to_phys_mapping);
 #endif
 }
 



