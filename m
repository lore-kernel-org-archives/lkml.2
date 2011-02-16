Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1BPVbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:31:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37369 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab1BPVb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 16:31:29 -0500
Date: Wed, 16 Feb 2011 14:31:26 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH TIP 02/14] x86: Add device tree support
Message-ID: <20110216213126.GC22837@angua.secretlab.ca>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
 <1295843342-1122-3-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295843342-1122-3-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 09:58:50AM +0530, Sebastian Andrzej Siewior wrote:
> This patch adds minimal support for device tree support on x86. It will
> be passed to the kernel via setup_data which requires atleast boot
> protocol 2.09.
> Memory size, restricted memory regions, boot arguments are gathered the
> traditional way so things like cmd_line are just here to let the code
> compile.
> The current plan is use the device tree as an extension and to gather
> informations from it which can not be enumerated and have to be
> hardcoded otherwise. This includes things like
> - which devices are on this I2C/ SPI bus?
> - how are the interrupts wired to IO APIC?
> - where could my hpet be?
> 
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
[...]
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d5ed94d..5d21095 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -297,6 +297,13 @@ config X86_BIGSMP
>  	---help---
>  	  This option is needed for the systems that have more than 8 CPUs
>  
> +config X86_OF
> +	bool "Support for device tree"
> +	select OF
> +	select OF_EARLY_FLATTREE
> +	---help---
> +	  Device tree support on X86.
> +

On ARM and MIPS, this is called 'config USE_OF'.  It would be nice to have
some commonality.  Maybe I should move the user-visible option to
drivers/of/Kconfig.  Or perhaps I should just make CONFIG_OF itself
user visible.

thoughts?

g.
