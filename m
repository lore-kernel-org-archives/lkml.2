Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2I0SWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:22:17 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:47488 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab2I0SWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:22:16 -0400
X-Greylist: delayed 864 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2012 14:22:16 EDT
From: Daniel Kiper <daniel.kiper@oracle.com>
To: konrad.wilk@oracle.com, andrew.cooper3@citrix.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH 00/11] xen: Initial kexec/kdump implementation
Date: Thu, 27 Sep 2012 20:06:27 +0200
Message-Id: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
X-Bogosity: No, spamicity=0.074274
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This set of patches contains initial kexec/kdump implementation for Xen.
Currently only dom0 is supported, however, almost all infrustructure
required for domU support is ready.

Daniel

 arch/x86/include/asm/kexec.h         |   10 +-
 arch/x86/include/asm/xen/hypercall.h |    6 +
 arch/x86/include/asm/xen/kexec.h     |   83 +++++++++
 arch/x86/kernel/machine_kexec_64.c   |   12 +-
 arch/x86/kernel/vmlinux.lds.S        |    7 +-
 arch/x86/xen/Makefile                |    3 +
 arch/x86/xen/enlighten.c             |   12 ++
 arch/x86/xen/kexec.c                 |  150 ++++++++++++++++
 arch/x86/xen/machine_kexec_32.c      |  245 ++++++++++++++++++++++++++
 arch/x86/xen/machine_kexec_64.c      |  301 +++++++++++++++++++++++++++++++
 arch/x86/xen/relocate_kernel_32.S    |  323 ++++++++++++++++++++++++++++++++++
 arch/x86/xen/relocate_kernel_64.S    |  309 ++++++++++++++++++++++++++++++++
 drivers/xen/sys-hypervisor.c         |   42 +++++-
 include/linux/kexec.h                |   18 ++
 include/xen/interface/xen.h          |   33 ++++
 kernel/kexec.c                       |  125 ++++++++++----
 16 files changed, 1636 insertions(+), 43 deletions(-)

Daniel Kiper (11):
      kexec: introduce kexec_ops struct
      x86/kexec: Add extra pointers to transition page table PGD, PUD, PMD and PTE
      xen: Introduce architecture independent data for kexec/kdump
      x86/xen: Introduce architecture dependent data for kexec/kdump
      x86/xen: Register resources required by kexec-tools
      x86/xen: Add i386 kexec/kdump implementation
      x86/xen: Add x86_64 kexec/kdump implementation
      x86/xen: Add kexec/kdump makefile rules
      x86/xen/enlighten: Add init and crash kexec/kdump hooks
      drivers/xen: Export vmcoreinfo through sysfs
      x86: Add Xen kexec control code size check to linker script
