Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263Ab2HITJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:09:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab2HITJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:09:25 -0400
Date: Thu, 9 Aug 2012 15:48:44 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 02/12] KVM: hide KVM_MEMSLOT_INVALID from userspace
Message-ID: <20120809184844.GA20889@amt.cnet>
References: <5020E423.9080004@linux.vnet.ibm.com>
 <5020E481.1050203@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5020E481.1050203@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 05:48:49PM +0800, Xiao Guangrong wrote:
> Quote Avi's comment:
> | KVM_MEMSLOT_INVALID is actually an internal symbol, not used by
> | userspace.  Please move it to kvm_host.h.
> 
> Also, move KVM_MEMSLOT_INVALID to the highest bit
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  include/linux/kvm.h      |    1 -
>  include/linux/kvm_host.h |    2 ++
>  2 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 2ce09aa..dc3aa2a 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -103,7 +103,6 @@ struct kvm_userspace_memory_region {
> 
>  /* for kvm_memory_region::flags */
>  #define KVM_MEM_LOG_DIRTY_PAGES  1UL
> -#define KVM_MEMSLOT_INVALID      (1UL << 1)
> 
>  /* for KVM_IRQ_LINE */
>  struct kvm_irq_level {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d2b897e..4c2da5a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -35,6 +35,8 @@
>  #define KVM_MMIO_SIZE 8
>  #endif
> 
> +#define KVM_MEMSLOT_INVALID	(1UL << 31)
> +
>  /*
>   * If we support unaligned MMIO, at most one fragment will be split into two:
>   */

Please document which range is for userspace visible flags, which range
is reserved. Mention that in both headers, point to each other
("userspace definitions are there" / "internal definitions are there").

16/16 bits for each should be fine.


