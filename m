Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1BLKhG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 05:37:06 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51894 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1BLKhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 05:37:02 -0500
Date: Sat, 12 Feb 2011 10:36:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 17/19] ARM: LPAE: mark memory banks with start >
	ULONG_MAX as highmem
Message-ID: <20110212103650.GE15616@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-18-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295891761-18366-18-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 05:55:59PM +0000, Catalin Marinas wrote:
> @@ -782,7 +782,8 @@ static void __init sanity_check_meminfo(void)
>  
>  #ifdef CONFIG_HIGHMEM
>  		if (__va(bank->start) > vmalloc_min ||
> -		    __va(bank->start) < (void *)PAGE_OFFSET)
> +		    __va(bank->start) < (void *)PAGE_OFFSET ||
> +		    bank->start > ULONG_MAX)

I think this check should be first, so that we don't try to evaluate __va()
on phys addresses > ULONG_MAX, possibly resulting in truncation.
