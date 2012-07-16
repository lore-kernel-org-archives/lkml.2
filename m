Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2GPUdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 16:33:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab2GPUdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 16:33:41 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v5 0/4] kvm: level irqfd and new eoifd
To: avi@redhat.com, mst@redhat.com
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Date: Mon, 16 Jul 2012 14:33:38 -0600
Message-ID: <20120716202711.1752.71007.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v5:
 - irqfds now have a one-to-one mapping with eoifds to prevent users
   from consuming all of kernel memory by repeatedly creating eoifds
   from a single irqfd.
 - implement a kvm_clear_irq() which does a test_and_clear_bit of
   the irq_state, only updating the pic/ioapic if changes and allowing
   the caller to know if anything was done.  I added this onto the end
   as it's essentially an optimization on the previous design.  It's
   hard to tell if there's an actual performance benefit to this.
 - dropped eoifd gsi support patch as it was only an FYI.

Thanks,

Alex

---

Alex Williamson (4):
      kvm: Convert eoifd to use kvm_clear_irq
      kvm: Create kvm_clear_irq()
      kvm: KVM_EOIFD, an eventfd for EOIs
      kvm: Extend irqfd to support level interrupts


 Documentation/virtual/kvm/api.txt |   28 +++
 arch/x86/kvm/x86.c                |    3 
 include/linux/kvm.h               |   18 ++
 include/linux/kvm_host.h          |   16 ++
 virt/kvm/eventfd.c                |  333 +++++++++++++++++++++++++++++++++++++
 virt/kvm/irq_comm.c               |   78 +++++++++
 virt/kvm/kvm_main.c               |   11 +
 7 files changed, 483 insertions(+), 4 deletions(-)
