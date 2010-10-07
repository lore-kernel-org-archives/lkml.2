Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605Ab0JGNhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 09:37:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab0JGNhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 09:37:32 -0400
Message-ID: <4CADCCF8.5000408@redhat.com>
Date: Thu, 07 Oct 2010 15:36:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 11/12] Let host know whether the guest can handle async
 PF in non-userspace context.
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-12-git-send-email-gleb@redhat.com>
In-Reply-To: <1286207794-16120-12-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/04/2010 05:56 PM, Gleb Natapov wrote:
> If guest can detect that it runs in non-preemptable context it can
> handle async PFs at any time, so let host know that it can send async
> PF even if guest cpu is not in userspace.
>
>
>
>   MSR_KVM_ASYNC_PF_EN: 0x4b564d02
>   	data: Bits 63-6 hold 64-byte aligned physical address of a 32bit memory
> -	area which must be in guest RAM. Bits 5-1 are reserved and should be
> +	area which must be in guest RAM. Bits 5-2 are reserved and should be
>   	zero. Bit 0 is 1 when asynchronous page faults are enabled on the vcpu
> -	0 when disabled.
> +	0 when disabled. Bit 2 is 1 if asynchronous page faults can be injected
> +	when vcpu is in kernel mode.

Please use cpl instead of user mode and kernel mode.  The original terms 
are ambiguous for cpl ==1 || cpl == 2.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

