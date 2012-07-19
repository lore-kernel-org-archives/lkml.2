Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab2GSKQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 06:16:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab2GSKQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 06:16:23 -0400
Message-ID: <5007DE72.6030300@redhat.com>
Date: Thu, 19 Jul 2012 13:16:18 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 08/10] KVM: introduce readonly_bad_hva
References: <5005791B.8040807@linux.vnet.ibm.com> <50057A73.40005@linux.vnet.ibm.com>
In-Reply-To: <50057A73.40005@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 05:45 PM, Xiao Guangrong wrote:
> In the later patch, it indicates failure when we try to get a writable
> hva from the readonly slot
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  virt/kvm/kvm_main.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b70f1a4..c056736 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -994,9 +994,19 @@ static inline unsigned long bad_hva(void)
>  	return PAGE_OFFSET;
>  }
> 
> +static inline unsigned long readonly_bad_hva(void)
> +{
> +	return PAGE_OFFSET + PAGE_SIZE;
> +}
> +
> +static int kvm_is_readonly_bad_hva(unsigned long addr)
> +{
> +	return addr == readonly_bad_hva();
> +}
> +
>  int kvm_is_error_hva(unsigned long addr)
>  {
> -	return addr == bad_hva();
> +	return addr == bad_hva() || kvm_is_readonly_bad_hva(addr);
>  }

addr >= PAGE_OFFSET.  Or change it to use -E*.



-- 
error compiling committee.c: too many arguments to function


