Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab0HXNNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:13:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab0HXNNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:13:11 -0400
Date: Tue, 24 Aug 2010 10:12:46 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH -kvm] kvm: fix regression from rework KVM mmu_shrink()
 code
Message-ID: <20100824131246.GB26660@amt.cnet>
References: <20100824020721.GA14726@amt.cnet>
 <1282617067-7686-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282617067-7686-1-git-send-email-dfeng@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 10:31:07AM +0800, Xiaotian Feng wrote:
> Latest kvm mmu_shrink code rework makes kernel changes kvm->arch.n_used_mmu_pages/
> kvm->arch.n_max_mmu_pages at kvm_mmu_free_page/kvm_mmu_alloc_page, which is called
> by kvm_mmu_commit_zap_page. So the kvm->arch.n_used_mmu_pages or
> kvm_mmu_available_pages(vcpu->kvm) is unchanged after kvm_mmu_prepare_zap_page(),
> This caused kvm_mmu_change_mmu_pages/__kvm_mmu_free_some_pages loops forever.
> Moving kvm_mmu_commit_zap_page would make the while loop performs as normal.
> 
> Reported-by: Avi Kivity <avi@redhat.com>
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Tested-by: Avi Kivity <avi@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)

Applied, thanks.

