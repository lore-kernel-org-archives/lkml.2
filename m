Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab2B0T5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:57:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54871 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab2B0T5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:57:07 -0500
Date: Mon, 27 Feb 2012 19:56:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@nvidia.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: boot/compressed/misc.s: Include <linux/bug.h> to
	fix build break
Message-ID: <20120227195637.GE2440@n2100.arm.linux.org.uk>
References: <1330372350-6432-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330372350-6432-1-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 12:52:30PM -0700, Stephen Warren wrote:
> Commmit cf86c17 "kernel.h: doesn't explicitly use bug.h, so don't include
> it." caused the following build failure on ARM:
> 
>   CC      arch/arm/boot/compressed/misc.o
> In file included from arch/arm/boot/compressed/misc.c:28:0:
> arch/arm/mach-tegra/include/mach/uncompress.h: In function 'arch_decomp_setup':
> arch/arm/mach-tegra/include/mach/uncompress.h:125:2: error: implicit declaration of function 'BUILD_BUG_ON_ZERO' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors

Err no.  The decompressor is _not_ part of the kernel, it's a separate
stand alone environment.  Including randomly kernel headers from the
rest of the kernel is bad news, particularly if they start calling out
to external code.

You should try to keep your uncompress.h as free of other dependencies
as possible.

> 
> Include <linux/bug.h> to fix that.
> 
> This should probably be squashed into commit a3a3a1a "bug.h: add include
> of it to various implicit C users".
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  arch/arm/boot/compressed/misc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
> index 8e2a8fc..30055be 100644
> --- a/arch/arm/boot/compressed/misc.c
> +++ b/arch/arm/boot/compressed/misc.c
> @@ -18,6 +18,7 @@
>  
>  unsigned int __machine_arch_type;
>  
> +#include <linux/bug.h>
>  #include <linux/compiler.h>	/* for inline */
>  #include <linux/types.h>
>  #include <linux/linkage.h>
> -- 
> 1.7.0.4
> 
