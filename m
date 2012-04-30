Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab2D3Ula (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:41:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757132Ab2D3Ul2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:41:28 -0400
Date: Mon, 30 Apr 2012 23:41:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] kvm: fix cpuid eax
Message-ID: <20120430204126.GA14876@redhat.com>
References: <20120430143902.GA10181@redhat.com>
 <4F9EF7FA.3060007@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9EF7FA.3060007@codemonkey.ws>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 03:37:14PM -0500, Anthony Liguori wrote:
> On 04/30/2012 09:39 AM, Michael S. Tsirkin wrote:
> >cpuid eax should return the max leaf so that
> >guests can find out the valid range.
> >This matches Xen et al.
> 
> What KVM does here predates Xen and Hyper-V.
> 
> This is an ABI breaker.

It is? I tested an old guest and qemu and both work fine.
What breaks?

> Regards,
> 
> Anthony Liguori
> 
> >
> >Tested using -cpu host.
> >
> >Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> >---
> >  arch/x86/kvm/cpuid.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> >diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >index 7d00d2d..bda4877 100644
> >--- a/arch/x86/kvm/cpuid.c
> >+++ b/arch/x86/kvm/cpuid.c
> >@@ -397,7 +397,7 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
> >  	case KVM_CPUID_SIGNATURE: {
> >  		char signature[12] = "KVMKVMKVM\0\0";
> >  		u32 *sigptr = (u32 *)signature;
> >-		entry->eax = 0;
> >+		entry->eax = KVM_CPUID_FEATURES;
> >  		entry->ebx = sigptr[0];
> >  		entry->ecx = sigptr[1];
> >  		entry->edx = sigptr[2];
