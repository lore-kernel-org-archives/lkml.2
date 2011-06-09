Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab1FIHOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:14:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab1FIHOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:14:43 -0400
Message-ID: <4DF072DE.8000700@redhat.com>
Date: Thu, 09 Jun 2011 10:14:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 13/15] KVM: VMX: modify the default value of nontrap shadow
 pte
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE2259.7080009@cn.fujitsu.com>
In-Reply-To: <4DEE2259.7080009@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 04:06 PM, Xiao Guangrong wrote:
> Modify the default value to identify nontrap shadow pte and mmio shadow pte
> whill will be introduced in later patch
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/vmx.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 20dbf7f..8c3d343 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -7110,7 +7110,7 @@ static int __init vmx_init(void)
>   		kvm_disable_tdp();
>
>   	if (bypass_guest_pf)
> -		kvm_mmu_set_nonpresent_ptes(~0xffeull, 0ull);
> +		kvm_mmu_set_nonpresent_ptes(0xfull<<  49 | 1ull, 0ull);
>

This can break on newer processors (well, so can the original, but the 
new one will break earlier).

-- 
error compiling committee.c: too many arguments to function

