Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab0KOXbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 18:31:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58865 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815Ab0KOXbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 18:31:51 -0500
Date: Mon, 15 Nov 2010 23:31:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/20] ARM: LPAE: Factor out 2-level page table
	definitions into separate files
Message-ID: <20101115233129.GG31421@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-3-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289584840-18097-3-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 06:00:22PM +0000, Catalin Marinas wrote:
> This patch moves page table definitions from asm/page.h, asm/pgtable.h
> and asm/ptgable-hwdef.h into corresponding *-2level* files.

This also introduces pteval_t.  It would be useful to have the
introduction of pteval_t as a separate patch, which not only
introduces the typedef, but also makes use of it.

> +#ifndef _ASM_PGTABLE_2LEVEL_TYPES_H
> +#define _ASM_PGTABLE_2LEVEL_TYPES_H
> +
> +#undef STRICT_MM_TYPECHECKS
> +
> +typedef unsigned long pteval_t;
> +
> +#ifdef STRICT_MM_TYPECHECKS
> +/*
> + * These are used to make use of C type-checking..
> + */
> +typedef struct { unsigned long pte; } pte_t;

This should become:

typedef struct { pteval_t pte; } pte_t;

L_PTE_* can then be declared using linux/const.h stuff to typedef them
to pteval_t.  shared_pte_mask also needs to be pteval_t.

As far as the __p*_error() functions, these should probably be passed
the pte/pmd/pgd value itself, rather than first passing them through
__pte_val() et.al.

Of couse, I now have patches for this and my other points... will sort
them out into a series in the next few days.
