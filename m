Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912Ab0JZO5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:57:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47874 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759871Ab0JZO5d (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 26 Oct 2010 10:57:33 -0400
Date: Tue, 26 Oct 2010 10:57:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, jeremy@goop.org,
        stefano.stabellini@eu.citrix.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] stable/xen-pcifront-0.8.2 for 2.6.37
Message-ID: <20101026145703.GF9557@dumpdata.com>
References: <alpine.LFD.2.00.1010211628010.2418@localhost6.localdomain6>
 <20101021150533.GA32607@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101021150533.GA32607@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 11:05:33AM -0400, Konrad Rzeszutek Wilk wrote:
> Hello Linus,
> 
> Please pull from:
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/xen-pcifront-0.8.2
> 
> for patches since git commit 032fa36091a925f555158f4e80f8a09d951cdb10
> Thomas Gleixner (1):
>     arm: Use ARCH_IRQ_INIT_FLAGS
> 
> [also known as "irq-core-for-linus"]. My patchset has been rebased on top of Thomas's
> sparse_irq work, but if you prefer to have it based off your tree (v2.6.36-rc7),
> there is stable/xen-pcifront-0.8.1 branch which has no sparse_irq work. If you
> choose that route, the patch "x86: xen: Sanitse irq handling (part two)"
> would have to be applied after tip/irq/core had been merged in after my patchset.
> I can follow up with that patch if you would like.

Linus,
Since the sparse_irq rework has been merged, please do git pull

    stable/xen-pcifront-0.8.2 

branch and ignore the stable/xen-pcifront-0.8.1.

Stephen found a contextual git merge error with the tree and the patch
below fixes the issue. I can rebase the tree of your latest but I am pretty
sure that is not the right way to do it, so I am leaving it as is. If however
you would like me to rebase on top of your tree I can definitly do it.

<begin copy-n-paste>
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

<end copy-n-paste>
