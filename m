Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1KTJTr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 04:19:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab1KTJTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 04:19:42 -0500
Message-ID: <4EC8C629.40705@redhat.com>
Date: Sun, 20 Nov 2011 11:19:37 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: KVM updates for 3.2-rc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/3.2

This includes a ppc ABI breakage fix, s390 fixes, a tracing/kvmclock
conflict fix, and the implementation of guest-only/host-only profiling
for Intel.  The latter is not strictly a fix, and missed the merge
window due to a combination of a dependency on tip.git, kernel.org being
offline, and me forgetting all about it.  However it would be good to
have the feature implemented fully instead of just on AMD as it is at
present.

Alexander Graf (1):
      Revert "KVM: PPC: Add support for explicit HIOR setting"

Avi Kivity (1):
      KVM guest: prevent tracing recursion with kvmclock

Christian Borntraeger (2):
      KVM: s390: Fix tprot locking
      KVM: s390: announce SYNC_MMU

Cornelia Huck (2):
      KVM: s390: Fix RUNNING flag misinterpretation
      KVM: s390: handle SIGP sense running intercepts

Gleb Natapov (3):
      KVM: VMX: add support for switching of PERF_GLOBAL_CTRL
      KVM: VMX: Add support for guest/host-only profiling
      KVM: VMX: Check for automatic switch msr table overflow

 arch/powerpc/include/asm/kvm.h        |    8 --
 arch/powerpc/include/asm/kvm_book3s.h |    2 -
 arch/powerpc/kvm/book3s_pr.c          |   14 +---
 arch/powerpc/kvm/powerpc.c            |    1 -
 arch/s390/include/asm/kvm_host.h      |    3 +-
 arch/s390/kvm/diag.c                  |    2 +-
 arch/s390/kvm/intercept.c             |    3 +-
 arch/s390/kvm/interrupt.c             |    1 +
 arch/s390/kvm/kvm-s390.c              |   12 ++-
 arch/s390/kvm/priv.c                  |   10 ++-
 arch/s390/kvm/sigp.c                  |   45 +++++++++++-
 arch/x86/kernel/kvmclock.c            |    5 +-
 arch/x86/kvm/vmx.c                    |  131
++++++++++++++++++++++++++++++---
 include/linux/kvm.h                   |    1 -
 14 files changed, 189 insertions(+), 49 deletions(-)

-- 
error compiling committee.c: too many arguments to function

