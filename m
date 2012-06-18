Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2FRKPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:15:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2FRKPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:15:42 -0400
Message-ID: <4FDEFFCA.7060403@redhat.com>
Date: Mon, 18 Jun 2012 13:15:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 4/6] KVM: pass slot to hva_to_pfn
References: <4FD6ADA6.40008@linux.vnet.ibm.com> <4FD6ADF6.2030802@linux.vnet.ibm.com>
In-Reply-To: <4FD6ADF6.2030802@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 05:48 AM, Xiao Guangrong wrote:
> This parameter will be used in the later patch
> 
> 
> -	return hva_to_pfn(kvm, addr, atomic, async, write_fault, writable);
> +	return hva_to_pfn(kvm, slot, addr, atomic, async, write_fault,
> +			  writable);
>  }
> 
>  pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn)
> @@ -1205,7 +1210,7 @@ pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
>  			 struct kvm_memory_slot *slot, gfn_t gfn)
>  {
>  	unsigned long addr = gfn_to_hva_memslot(slot, gfn);
> -	return hva_to_pfn(kvm, addr, false, NULL, true, NULL);
> +	return hva_to_pfn(kvm, slot, addr, false, NULL, true, NULL);
>  }
> 
>  pfn_t gfn_to_pfn_memslot_atomic(struct kvm *kvm,
> @@ -1213,7 +1218,7 @@ pfn_t gfn_to_pfn_memslot_atomic(struct kvm *kvm,
>  {
>  	unsigned long addr = gfn_to_hva_memslot(slot, gfn);
> 
> -	return hva_to_pfn(kvm, addr, true, NULL, true, NULL);
> +	return hva_to_pfn(kvm, slot, addr, true, NULL, true, NULL);
>  }

It was unreadable before, but now it's even more unreadable.



-- 
error compiling committee.c: too many arguments to function


