Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2FOLbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 07:31:00 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:39687 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab2FOLa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 07:30:58 -0400
Date: Fri, 15 Jun 2012 20:30:07 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: avi@redhat.com, mtosatti@redhat.com
Cc: agraf@suse.de, paulus@samba.org, aarcange@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: [RFC PATCH 0/4] KVM: Optimize MMU notifier's THP page invalidation
Message-Id: <20120615203007.4f61bb17.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takuya Yoshikawa (4):
  KVM: MMU: Use __gfn_to_rmap() to clean up kvm_handle_hva()
  KVM: Introduce hva_to_gfn() for kvm_handle_hva()
  KVM: MMU: Make kvm_handle_hva() handle range of addresses
  KVM: Introduce kvm_unmap_hva_range() for kvm_mmu_notifier_invalidate_range_start()

 arch/powerpc/include/asm/kvm_host.h |    2 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c |   38 +++++++++++++++++++-------
 arch/x86/include/asm/kvm_host.h     |    1 +
 arch/x86/kvm/mmu.c                  |   51 +++++++++++++++++++++++-----------
 include/linux/kvm_host.h            |    7 +++++
 virt/kvm/kvm_main.c                 |    3 +-
 6 files changed, 73 insertions(+), 29 deletions(-)

-- 
1.7.5.4

