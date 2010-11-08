Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0KHUVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 15:21:21 -0500
Received: from www.tglx.de ([62.245.132.106]:52107 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab0KHUVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 15:21:20 -0500
Date: Mon, 8 Nov 2010 21:21:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: Re: [PATCH] x86: fix apic.h unused but set warnings
In-Reply-To: <1289159606-17417-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.00.1011082114360.2900@localhost6.localdomain6>
References: <1289159606-17417-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Nov 2010, Andi Kleen wrote:
>  static inline u32 native_apic_msr_read(u32 reg)
>  {
> -	u32 low, high;
> +	u32 low;
>  
>  	if (reg == APIC_DFR)
>  		return -1;
>  
> -	rdmsr(APIC_BASE_MSR + (reg >> 4), low, high);
> +	rdmsrl(APIC_BASE_MSR + (reg >> 4), low);
>  	return low;
>  }
>  
> @@ -181,12 +181,12 @@ extern void enable_x2apic(void);
>  extern void x2apic_icr_write(u32 low, u32 id);
>  static inline int x2apic_enabled(void)
>  {
> -	int msr, msr2;
> +	int msr;

Please make this an u32 while at it.

Thanks,

	tglx
