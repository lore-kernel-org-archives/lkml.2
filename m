Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab1KJWp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 17:45:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40324 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab1KJWp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 17:45:58 -0500
Date: Thu, 10 Nov 2011 22:45:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 04/16] ARM: LPAE: Move the FSR definitions to
	separate files
Message-ID: <20111110224545.GU12913@n2100.arm.linux.org.uk>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com> <1320682618-1182-5-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320682618-1182-5-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 04:16:46PM +0000, Catalin Marinas wrote:
> diff --git a/arch/arm/mm/fault.h b/arch/arm/mm/fault.h
> index 49e9e38..25b45c1 100644
> --- a/arch/arm/mm/fault.h
> +++ b/arch/arm/mm/fault.h
> @@ -1,3 +1,20 @@
> -void do_bad_area(unsigned long addr, unsigned int fsr, struct pt_regs *regs);
> +#ifndef __ARCH_ARM_FAULT_H
> +#define __ARCH_ARM_FAULT_H
> +
> +/*
> + * Fault status register encodings.  We steal bit 31 for our own purposes.
> + */
> +#define FSR_LNX_PF		(1 << 31)
> +#define FSR_WRITE		(1 << 11)
> +#define FSR_FS4			(1 << 10)
> +#define FSR_FS3_0		(15)
> +
> +static inline int fsr_fs(unsigned int fsr)
> +{
> +	return (fsr & FSR_FS3_0) | (fsr & FSR_FS4) >> 6;
> +}

Much better.
