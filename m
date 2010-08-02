Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab0HBHlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:41:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab0HBHlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:41:13 -0400
Message-ID: <4C567694.2090808@redhat.com>
Date: Mon, 02 Aug 2010 10:41:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: MMU: move bits lost judgement into a separate
 function
References: <4C4E5313.1080308@cn.fujitsu.com> <4C4E536E.7030109@cn.fujitsu.com>
In-Reply-To: <4C4E536E.7030109@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/27/2010 06:33 AM, Xiao Guangrong wrote:
> Introduce spte_bits_lost() function to judge whether spte bits will
> miss, it's more readable and can help us to cleanup code later
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c |   20 +++++++++++++++++---
>   1 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index e10f2bd..dd6c192 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -303,6 +303,20 @@ static u64 __xchg_spte(u64 *sptep, u64 new_spte)
>   #endif
>   }
>
> +static bool spte_bits_lost(u64 spte)
> +{
> +	if (!shadow_accessed_mask)
> +		return false;
> +
> +	if (!is_shadow_present_pte(spte))
> +		return false;
> +
> +	if (spte&  shadow_accessed_mask)
> +		return false;
> +
> +	return true;
> +}

IMO spte_has_volatile_bits() is a clearer name, "lost" implies they are 
already gone.


-- 
error compiling committee.c: too many arguments to function

