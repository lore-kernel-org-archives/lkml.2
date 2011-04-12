Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1DLLQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 07:16:04 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:51031 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1DLLQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 07:16:03 -0400
X-IronPort-AV: E=Sophos;i="4.64,194,1301875200"; 
   d="scan'208";a="5261097"
Date: Tue, 12 Apr 2011 12:16:20 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/4] xen: critical bug fixes for 2.6.39-rc3
Message-ID: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this is a small collection of critical xen bug fixes for 2.6.39-rc3:
the recent changes to the initial kernel pagetable allocation mechanism
(4b239f458c229de044d6905c2b0f9fe16ed9e01e in particular) caused a number
of issues on Xen.
This patch series fixes those issues and it is required just to boot a
2.6.39 linux kernel as regular xen guest.


The list of patches with a diffstat follows:

Stefano Stabellini (4):
      xen: mask_rw_pte mark RO all pagetable pages up to pgt_buf_top
      x86,xen: introduce x86_init.mapping.pagetable_reserve
      xen: more debugging in the e820 parsing
      xen: do not create the extra e820 region at an addr lower than 4G

 arch/x86/include/asm/pgtable_types.h |    1 +
 arch/x86/include/asm/x86_init.h      |    9 +++++++++
 arch/x86/kernel/x86_init.c           |    4 ++++
 arch/x86/mm/init.c                   |    9 +++++++--
 arch/x86/xen/mmu.c                   |   17 ++++++++++++++++-
 arch/x86/xen/setup.c                 |    6 +++++-
 6 files changed, 42 insertions(+), 4 deletions(-)


The first two commits make sure pagetable pages are marked RO while
other pages are marked RW.

The third commit adds a couple of useful debugging statements.

The fourth commit fixes a boot crash on xen when booting as initial
domain: the xen extra memory region shouldn't start below 4G otherwise
e820_end_of_low_ram_pfn() could return an address above 4G. As a
consequence init_memory_mapping would end up mapping MMIO regions
without going through the fixmap.


A git branch with this series is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.39-rc3-fixes


Comments are welcome.

- Stefano
