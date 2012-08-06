Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2HFLMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 07:12:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55177 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab2HFLMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 07:12:41 -0400
Date: Mon, 6 Aug 2012 12:12:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Cyril Chemparathy <cyril@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, catalin.marinas@arm.com, nico@linaro.org,
        will.deacon@arm.com
Subject: Re: [PATCH 01/22] ARM: add mechanism for late code patching
Message-ID: <20120806111224.GA18957@n2100.arm.linux.org.uk>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-2-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343775898-28345-2-git-send-email-cyril@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 07:04:37PM -0400, Cyril Chemparathy wrote:
> +static void __init init_patch_kernel(void)
> +{
> +	const void *start = &__patch_table_begin;
> +	const void *end   = &__patch_table_end;
> +
> +	BUG_ON(patch_kernel(start, end - start));
> +	flush_icache_range(init_mm.start_code, init_mm.end_code);

Err.  You are asking the kernel to flush every single cache line
manually throughout the kernel code.  That's a flush every 32-bytes
over maybe a few megabytes of address space.

This is one of the reasons we do the patching in assembly code before
the caches are enabled - so we don't have to worry about the interaction
with the CPU caches, which for this kind of application would be very
expensive.
