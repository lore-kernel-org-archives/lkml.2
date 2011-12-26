Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab1LZOCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 09:02:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab1LZOCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 09:02:45 -0500
Message-ID: <4EF87E81.1020708@redhat.com>
Date: Mon, 26 Dec 2011 16:02:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>
Subject: [GIT PULL] KVM fixes for 3.2-rc7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/3.2

to receive an unfortunately large bunch of fixes for Linux 3.2 KVM, some
fairly critical:

 - two DoS issues in the device assignment code
 - an oops in the emulated PIT code
 - the regression caused by incorrect exposure of the TSC deadline timer
feature to guests
 - a few powerpc build fixes

Alex Williamson (2):
      KVM: Remove ability to assign a device without iommu support
      KVM: Device assignment permission checks

Andreas Schwab (2):
      KVM: PPC: move compute_tlbie_rb to book3s_64 common header
      KVM: PPC: protect use of kvmppc_h_pr

Jan Kiszka (2):
      KVM: x86: Prevent starting PIT timers in the absence of irqchip
support
      KVM: Don't automatically expose the TSC deadline timer in cpuid

Michael Neuling (1):
      KVM: PPC: fix kvmppc_start_thread() for CONFIG_SMP=N

Scott Wood (1):
      KVM: PPC: e500: include linux/export.h

 Documentation/virtual/kvm/api.txt        |   16 +++++
 arch/powerpc/include/asm/kvm_book3s.h    |   33 -----------
 arch/powerpc/include/asm/kvm_book3s_64.h |   33 +++++++++++
 arch/powerpc/kvm/book3s_hv.c             |    2 +-
 arch/powerpc/kvm/book3s_pr.c             |    2 +
 arch/powerpc/kvm/e500.c                  |    1 +
 arch/x86/kvm/i8254.c                     |   10 ++-
 arch/x86/kvm/x86.c                       |   19 +++---
 include/linux/kvm.h                      |    1 +
 virt/kvm/assigned-dev.c                  |   93
+++++++++++++++++++++++++++---
 10 files changed, 154 insertions(+), 56 deletions(-)

-- 
error compiling committee.c: too many arguments to function

