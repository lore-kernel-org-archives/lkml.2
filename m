Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab0GROEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 10:04:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab0GROEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 10:04:42 -0400
Message-ID: <4C4309F5.9080300@redhat.com>
Date: Sun, 18 Jul 2010 17:04:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/6] kvm: pass error code to handler
References: <4C3FC025.9070707@cn.fujitsu.com>
In-Reply-To: <4C3FC025.9070707@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 05:12 AM, Lai Jiangshan wrote:
> handle_ept_violation() does not pass error code to
> the handler tdp_page_fault().
>
> It means tdp_page_fault() handles the page fault with ignoring
> the error code, It will not handle the page fault completely correctly,
> and may causes endless page fault.
>
>    

Please describe the fail scenario more accurately in the change log?

Can it happen now, or only with the next patches in the series?

> @@ -3521,7 +3521,8 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>
>   	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
>   	trace_kvm_page_fault(gpa, exit_qualification);
> -	return kvm_mmu_page_fault(vcpu, gpa&  PAGE_MASK, 0);
> +	return kvm_mmu_page_fault(vcpu, gpa&  PAGE_MASK,
> +			exit_qualification&  0x2);
>   }
>
>    

Symbolic constant please.

I don't really like how kvm_mmu_page_fault() is overloaded, for !tdp the 
parameter is a gva, for tdp it is a gpa.  We need to break it into two 
(but later).

-- 
error compiling committee.c: too many arguments to function

