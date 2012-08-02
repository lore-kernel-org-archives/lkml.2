Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab2HBNTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:19:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab2HBNSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:18:16 -0400
Date: Thu, 2 Aug 2012 09:54:29 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 7/9] KVM: define kvm_bad_page statically
Message-ID: <20120802125429.GC25344@amt.cnet>
References: <5014F053.8020305@linux.vnet.ibm.com>
 <5014F15C.60400@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5014F15C.60400@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 04:16:28PM +0800, Xiao Guangrong wrote:
> It is used to eliminate the overload of function call and cleanup
> the code
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  include/linux/kvm_host.h |    9 +++++++--
>  virt/kvm/async_pf.c      |    2 +-
>  virt/kvm/kvm_main.c      |   13 +------------
>  3 files changed, 9 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 387ecc5..08a9da9 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -68,6 +68,13 @@ static inline int is_invalid_pfn(pfn_t pfn)
>  	return !is_noslot_pfn(pfn) && is_error_pfn(pfn);
>  }
> 
> +#define kvm_bad_page	(ERR_PTR(-ENOENT))

KVM_ERR_PTR_BAD_PAGE ...


