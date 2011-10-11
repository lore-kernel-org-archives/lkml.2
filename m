Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1JKShN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:37:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab1JKShL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:37:11 -0400
Date: Tue, 11 Oct 2011 20:38:04 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 0/2] kvm: set irq affinity for assigned devices
Message-ID: <cover.1318358229.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To forward an interrupt to a vcpu that runs on
a host cpu different from the current one,
we need an ipi which likely will cost us as much
as delivering the interrupt directly to that cpu would.
    
So it seems to make sense to set irq affinity hint to point there, irq
balancer can then take this into accound and balance interrupts
accordingly.

This is what this patchset does.
Note: it might make sense to optimize the gsi lookups
here for the msi case, using rcu, the way we did for eventfd.
But that's a subject for another patch.

Warning: compiled only.

Any early comments / flames?

Thanks,

-- 
MST


Michael S. Tsirkin (2):
  kvm: pass host irq number to set irq calls
  kvm: set affinity hint for assigned device msi

 arch/x86/kvm/i8254.c     |    4 ++--
 arch/x86/kvm/lapic.c     |    2 +-
 arch/x86/kvm/x86.c       |    2 +-
 include/linux/kvm_host.h |    7 ++++---
 virt/kvm/assigned-dev.c  |   17 ++++++++++-------
 virt/kvm/eventfd.c       |    7 ++++---
 virt/kvm/ioapic.c        |    2 +-
 virt/kvm/ioapic.h        |    2 +-
 virt/kvm/irq_comm.c      |   35 +++++++++++++++++++++++++++--------
 9 files changed, 51 insertions(+), 27 deletions(-)

-- 
1.7.5.53.gc233e
