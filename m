Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2D3UhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:37:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39770 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab2D3UhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:37:21 -0400
Message-ID: <4F9EF7FA.3060007@codemonkey.ws>
Date: Mon, 30 Apr 2012 15:37:14 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] kvm: fix cpuid eax
References: <20120430143902.GA10181@redhat.com>
In-Reply-To: <20120430143902.GA10181@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 09:39 AM, Michael S. Tsirkin wrote:
> cpuid eax should return the max leaf so that
> guests can find out the valid range.
> This matches Xen et al.

What KVM does here predates Xen and Hyper-V.

This is an ABI breaker.

Regards,

Anthony Liguori

>
> Tested using -cpu host.
>
> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> ---
>   arch/x86/kvm/cpuid.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7d00d2d..bda4877 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -397,7 +397,7 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>   	case KVM_CPUID_SIGNATURE: {
>   		char signature[12] = "KVMKVMKVM\0\0";
>   		u32 *sigptr = (u32 *)signature;
> -		entry->eax = 0;
> +		entry->eax = KVM_CPUID_FEATURES;
>   		entry->ebx = sigptr[0];
>   		entry->ecx = sigptr[1];
>   		entry->edx = sigptr[2];

