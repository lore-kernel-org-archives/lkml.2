Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0LCUhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 15:37:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46919 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab0LCUhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 15:37:31 -0500
Date: Fri, 3 Dec 2010 20:36:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwalker@codeaurora.org, Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nico@marvell.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] arm: dma-mapping: move consistent_init to early_initcall
Message-ID: <20101203203653.GB10245@n2100.arm.linux.org.uk>
References: <1291327879-28073-1-git-send-email-johlstei@codeaurora.org> <20101202221909.GK29347@n2100.arm.linux.org.uk> <4CF94DDD.8000409@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF94DDD.8000409@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 12:06:53PM -0800, Saravana Kannan wrote:
> The MSM8660 SoC uses the TrustZone technology and the Linux kernel  
> executes in normal/non-secure domain. When the second core is brought  
> out of reset, it starts executing a secure image which then jumps to  
> "secondary_startup". So, before bringing the second core out of reset,  
> we need to inform the secure domain code where secondary_startup is  
> located in memory.
>
> We do the communication with the secure code by using buffers in memory.  
>  The cache treats the NS (non secure) bit as an additional address bit  
> when tagging memory. Hence, cache accesses are not coherent between the  
> secure and non-secure domains. So, the secure side flushes it's cache  
> after writing to the buffer. To properly read the response from the  
> secure side, the kernel has to pick a buffer that isn't cacheable in the  
> first place. We have similar issues in the reverse direction.

So when ARM gets DMA-coherent caches, you of course aren't going to
complain that the DMA APIs start avoiding doing the current tricks with
non-cacheable memory?

I view what you're doing above with the DMA API as an abuse of the API.
Just like the problems we're facing with ioremap() being used on system
RAM, you're asking for problems when the ARM architecture changes because
you're using an API for it's current properties, not for its purpose.

I've been on for years about purpose-designed APIs for cache issues,
and every time someone abuses them, they eventually end up suffering
breakage.

Let's wait until the full set of patches is available before discussing
further.
