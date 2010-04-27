Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab0D0PYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:24:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab0D0PYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:24:44 -0400
Date: Tue, 27 Apr 2010 11:24:42 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com, drjones@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH] Fix NULL pointer for Xen guests
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upstream PV guests fail to boot because of a NULL pointer.  It is possible that
xen guests have irq_desc->chip_data = NULL.

Test for NULL chip_data pointer before attempting to complete an irq move.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 127b871..eb2789c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2545,6 +2545,9 @@ void irq_force_complete_move(int irq)
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg = desc->chip_data;
 
+	if (!cfg)
+		return;
+
 	__irq_complete_move(&desc, cfg->vector);
 }
 #else
