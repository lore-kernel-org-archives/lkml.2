Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab0KHVkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:40:09 -0500
Received: from www.tglx.de ([62.245.132.106]:43631 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923Ab0KHVkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:40:07 -0500
Date: Mon, 8 Nov 2010 22:39:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, x86@kernel.org
Subject: Re: [PATCH] x86: fix apic.h unused but set warnings v2
In-Reply-To: <1289251229-19589-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.00.1011082238420.2900@localhost6.localdomain6>
References: <1289251229-19589-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Nov 2010, Andi Kleen wrote:
>  static inline u32 native_apic_msr_read(u32 reg)
>  {
> -	u32 low, high;
> +	u32 low;
>  
>  	if (reg == APIC_DFR)
>  		return -1;
>  
> -	rdmsr(APIC_BASE_MSR + (reg >> 4), low, high);
> -	return low;
> +	rdmsrl(APIC_BASE_MSR + (reg >> 4), low);
> +	return (u32)low;

What's the point of casting u32 to u32 ?

Thanks,

	tglx
