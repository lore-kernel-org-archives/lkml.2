Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1FSSWG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 14:22:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab1FSSWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 14:22:04 -0400
Message-ID: <4DFE3E41.4040602@redhat.com>
Date: Sun, 19 Jun 2011 21:21:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kvm-devel <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] KVM updates for Linux 3.0-rc3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

   git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/3.0

to receive several (fairly serious) KVM fixes: kvmclock was broken due 
to bad asm constraints, live migration & vga tracking instantiated large 
ptes instead of small ones, and the guest cr3 was corrupted in some 
scenarios.


Borislav Petkov (1):
       KVM: MMU: Fix build warnings in walk_addr_generic()

Marcelo Tosatti (1):
       KVM: VMX: do not overwrite uptodate vcpu->arch.cr3 on KVM_SET_SREGS

Steve (1):
       KVM: MMU: fix opposite condition in mapping_level_dirty_bitmap

Zachary Amsden (1):
       KVM: Fix register corruption in pvclock_scale_delta

  arch/x86/include/asm/pvclock.h |    9 +++++++--
  arch/x86/kvm/mmu.c             |    2 +-
  arch/x86/kvm/paging_tmpl.h     |    2 +-
  arch/x86/kvm/vmx.c             |    3 ++-
  4 files changed, 11 insertions(+), 5 deletions(-)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

