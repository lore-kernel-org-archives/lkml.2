Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab1JXJDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:03:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37650 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1JXJDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:03:31 -0400
Subject: Re: [PATCH RFC V2 5/5] kvm guest : pv-ticketlocks support for
 linux guests running on KVM hypervisor
From: Sasha Levin <levinsasha928@gmail.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>, x86@kernel.org,
        KVM <kvm@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Sedat Dilek <sedat.dilek@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xen <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Suzuki Poulose <suzuki@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20111023190753.16364.31164.sendpatchset@oc5400248562.ibm.com>
References: <20111023190307.16364.35381.sendpatchset@oc5400248562.ibm.com>
	 <20111023190753.16364.31164.sendpatchset@oc5400248562.ibm.com>
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 24 Oct 2011 12:01:54 +0200
Message-ID: <1319450514.5660.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-24 at 00:37 +0530, Raghavendra K T wrote:
> This patch extends Linux guests running on KVM hypervisor to support
> pv-ticketlocks. Very early during bootup, paravirtualied KVM guest detects if 
> the hypervisor has required feature (KVM_FEATURE_WAIT_FOR_KICK) to support 
> pv-ticketlocks. If so, support for pv-ticketlocks is registered via pv_lock_ops.
> 
> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 2874c19..c7f34b7 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -195,10 +195,18 @@ void kvm_async_pf_task_wait(u32 token);
>  void kvm_async_pf_task_wake(u32 token);
>  u32 kvm_read_and_reset_pf_reason(void);
>  extern void kvm_disable_steal_time(void);
> -#else
> +
> +#ifdef CONFIG_PARAVIRT_SPINLOCKS
> +void __init kvm_guest_early_init(void);
> +#else /* CONFIG_PARAVIRT_SPINLOCKS */
> +#define kvm_guest_early_init() do { } while (0)

This should be defined as an empty function.

-- 

Sasha.

