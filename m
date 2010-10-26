Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0JZCDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:03:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45841 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715Ab0JZCDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:03:39 -0400
Date: Tue, 26 Oct 2010 13:03:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: linux-next: manual merge of the swiotlb-xen tree with the tip tree
Message-Id: <20101026130332.002937e5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

Today's linux-next merge of the swiotlb-xen tree got a conflict in
arch/x86/include/asm/io_apic.h between commit
23f9b267159b4c7ff59d2e6c8ed31693eff841e3 ("x86: apic: Move
probe_nr_irqs_gsi() into ioapic_init_mappings()") from the tip tree and
commit 7b586d71858091f0958e5808b7e3d5390c2ae47d ("x86/io_apic: add
get_nr_irqs_gsi()") from the swiotlb-xen tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/asm/io_apic.h
index 240a0a5,a6b28d0..0000000
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@@ -168,6 -168,9 +168,8 @@@ extern int save_IO_APIC_setup(struct IO
  extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
  extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
  
 -extern void probe_nr_irqs_gsi(void);
+ extern int get_nr_irqs_gsi(void);
+ 
  extern void setup_ioapic_ids_from_mpc(void);
  
  struct mp_ioapic_gsi{
