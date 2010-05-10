Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab0EJXgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:36:42 -0400
Received: from kroah.org ([198.145.64.141]:33105 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413Ab0EJWwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:17 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:21 2010
Message-Id: <20100510223321.884133098@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Prarit Bhargava <prarit@redhat.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [052/117] x86: Fix NULL pointer access in irq_force_complete_move() for Xen guests
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Prarit Bhargava <prarit@redhat.com>

commit bbd391a15d82e14efe9d69ba64cadb855b061dba upstream.

Upstream PV guests fail to boot because of a NULL pointer in
irq_force_complete_move().  It is possible that xen guests have
irq_desc->chip_data = NULL.

Test for NULL chip_data pointer before attempting to complete an irq move.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
LKML-Reference: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/io_apic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2539,6 +2539,9 @@ void irq_force_complete_move(int irq)
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg = desc->chip_data;
 
+	if (!cfg)
+		return;
+
 	__irq_complete_move(&desc, cfg->vector);
 }
 #else


