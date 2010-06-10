Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab0FJJcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 05:32:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab0FJJcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 05:32:08 -0400
Message-ID: <4C10B10D.80304@redhat.com>
Date: Thu, 10 Jun 2010 12:31:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM updates for 2.6.35-rc2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.35

to receive a bunch of KVM fixes for 2.6.35-rc2, including a workaround 
for a cpu erratum that can allow a guest to crash the host.

Avi Kivity (1):
       KVM: MMU: Remove user access when allowing kernel access to 
gpte.w=0 page

Huang Ying (1):
       KVM: Avoid killing userspace through guest SRAO MCE on unmapped pages

Jan Kiszka (1):
       KVM: Fix order passed to iommu_unmap

Jean Delvare (1):
       KVM: powerpc: fix init/exit annotation

Joerg Roedel (2):
       KVM: SVM: Handle MCEs early in the vmexit process
       KVM: SVM: Implement workaround for Erratum 383

Julia Lawall (1):
       KVM: ia64: Add missing spin_unlock in kvm_arch_hardware_enable()

Marcelo Tosatti (2):
       KVM: MMU: invalidate and flush on spte small->large page size change
       KVM: read apic->irr with ioapic lock held

  arch/ia64/kvm/kvm-ia64.c         |    1 +
  arch/powerpc/kvm/e500.c          |    2 +-
  arch/x86/include/asm/msr-index.h |    1 +
  arch/x86/kvm/mmu.c               |   39 ++++++++++++---
  arch/x86/kvm/paging_tmpl.h       |    7 +--
  arch/x86/kvm/svm.c               |   96 
+++++++++++++++++++++++++++++++++++++-
  include/linux/kvm_host.h         |    1 +
  include/linux/mm.h               |    8 +++
  mm/memory-failure.c              |   30 ++++++++++++
  virt/kvm/ioapic.c                |    3 +-
  virt/kvm/iommu.c                 |    2 +-
  virt/kvm/kvm_main.c              |   30 +++++++++++-
  12 files changed, 201 insertions(+), 19 deletions(-)

-- 
error compiling committee.c: too many arguments to function

