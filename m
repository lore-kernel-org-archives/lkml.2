Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2DAPwI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 11:52:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab2DAPwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 11:52:07 -0400
Message-ID: <4F7879A1.2020301@redhat.com>
Date: Sun, 01 Apr 2012 18:52:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 08/13] KVM: MMU: fask check whether page is writable
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742A74.1050304@linux.vnet.ibm.com>
In-Reply-To: <4F742A74.1050304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 11:25 AM, Xiao Guangrong wrote:
> Using PTE_LIST_WRITE_PROTECT bit in rmap store the write-protect status to
> avoid unnecessary shadow page walking
>
> Also if no shadow page is indirect, the page is write-free
>
>
> @@ -2262,6 +2291,9 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>  	}
>  	if (need_unsync)
>  		kvm_unsync_pages(vcpu, gfn);
> +
> +	*rmap &= ~PTE_LIST_WRITE_PROTECT;
> +
>

So what are the rules for PTE_LIST_WRITE_PROTECT?  Is is a cache for the
mmu_need_write_protect?

I'd like to understand it, I guess it can be set while write protection
is unneeded, and cleared on the next check?

Maybe split into two functions, one the normal mmu_need_write_protect
(but renamed) and a new mmu_need_write_protect(), with locked and
unlocked variants, calling the old one.

-- 
error compiling committee.c: too many arguments to function

