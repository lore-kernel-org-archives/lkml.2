Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3AJRu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:50:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444Ab3AJRuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:50:55 -0500
Date: Thu, 10 Jan 2013 15:49:56 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
Cc: gleb@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7 -v2] KVM: Alleviate mmu_lock hold time when we start
 dirty logging
Message-ID: <20130110174956.GC25050@amt.cnet>
References: <20130108194238.09ebc8bd.yoshikawa_takuya_b1@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108194238.09ebc8bd.yoshikawa_takuya_b1@lab.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 07:42:38PM +0900, Takuya Yoshikawa wrote:
> Changelog v1->v2:
>   The condition in patch 1 was changed like this:
>     npages && (mem->flags & KVM_MEM_LOG_DIRTY_PAGES)
> 
> This patch set makes kvm_mmu_slot_remove_write_access() rmap based and
> adds conditional rescheduling to it.
> 
> The motivation for this change is of course to reduce the mmu_lock hold
> time when we start dirty logging for a large memory slot.  You may not
> see the problem if you just give 8GB or less of the memory to the guest
> with THP enabled on the host -- this is for the worst case.
> 
> Takuya Yoshikawa (7):
>   KVM: Write protect the updated slot only when dirty logging is enabled
>   KVM: MMU: Remove unused parameter level from __rmap_write_protect()
>   KVM: MMU: Make kvm_mmu_slot_remove_write_access() rmap based
>   KVM: Remove unused slot_bitmap from kvm_mmu_page
>   KVM: Make kvm_mmu_change_mmu_pages() take mmu_lock by itself
>   KVM: Make kvm_mmu_slot_remove_write_access() take mmu_lock by itself
>   KVM: MMU: Conditionally reschedule when kvm_mmu_slot_remove_write_access() takes a long time
> 
>  Documentation/virtual/kvm/mmu.txt |    7 ----
>  arch/x86/include/asm/kvm_host.h   |    5 ---
>  arch/x86/kvm/mmu.c                |   56 +++++++++++++++++++-----------------
>  arch/x86/kvm/x86.c                |   12 ++++---
>  virt/kvm/kvm_main.c               |    1 -
>  5 files changed, 37 insertions(+), 44 deletions(-)
> 
> -- 
> 1.7.5.4

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

