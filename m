Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab1AKKlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:41:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40025 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab1AKKk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:40:59 -0500
Date: Tue, 11 Jan 2011 10:40:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Nicolas Pitre <nicolas.pitre@canonical.com>
Subject: Re: [RFC] arm: Defer lookup of machine_type and vet of atags to
	setup.c
Message-ID: <20110111104051.GA11039@n2100.arm.linux.org.uk>
References: <20110111015409.18291.87166.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110111015409.18291.87166.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 07:15:53PM -0700, Grant Likely wrote:
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index 6bd82d2..9c0e938 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -87,11 +87,6 @@ ENTRY(stext)
>  	movs	r10, r5				@ invalid processor (r5=0)?
>   THUMB( it	eq )		@ force fixup-able long branch encoding
>  	beq	__error_p			@ yes, error 'p'
> -	bl	__lookup_machine_type		@ r5=machinfo
> -	movs	r8, r5				@ invalid machine (r5=0)?
> - THUMB( it	eq )		@ force fixup-able long branch encoding
> -	beq	__error_a			@ yes, error 'a'
> -	bl	__vet_atags
>  #ifdef CONFIG_SMP_ON_UP
>  	bl	__fixup_smp
>  #endif

Don't forget to update the comments as well - there's two of them.
