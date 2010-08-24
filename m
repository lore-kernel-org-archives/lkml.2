Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0HXJca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:32:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab0HXJc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:32:26 -0400
Message-ID: <4C739178.1070405@redhat.com>
Date: Tue, 24 Aug 2010 12:31:36 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v5 11/12] Let host know whether the guest can handle async
 PF in non-userspace context.
References: <1279553462-7036-1-git-send-email-gleb@redhat.com> <1279553462-7036-12-git-send-email-gleb@redhat.com>
In-Reply-To: <1279553462-7036-12-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/19/2010 06:31 PM, Gleb Natapov wrote:
> If guest can detect that it runs in non-preemptable context it can
> handle async PFs at any time, so let host know that it can send async
> PF even if guest cpu is not in userspace.
>
> Acked-by: Rik van Riel<riel@redhat.com>
> Signed-off-by: Gleb Natapov<gleb@redhat.com>
> ---
>   arch/x86/include/asm/kvm_host.h |    1 +
>   arch/x86/include/asm/kvm_para.h |    1 +
>   arch/x86/kernel/kvm.c           |    3 +++
>   arch/x86/kvm/x86.c              |    5 +++--
>   4 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 45e6c12..c675d5d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -367,6 +367,7 @@ struct kvm_vcpu_arch {
>   	cpumask_var_t wbinvd_dirty_mask;
>
>   	u32 __user *apf_data;
> +	bool apf_send_user_only;
>   	u32 apf_memslot_ver;
>   	u64 apf_msr_val;
>   	u32 async_pf_id;

Lots of apf stuff in here.  Make it apg.data etc.?

-- 
error compiling committee.c: too many arguments to function

