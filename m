Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2IHVoF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 17:44:05 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:59399 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab2IHVoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 17:44:02 -0400
Date: Sat, 8 Sep 2012 23:43:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 01/10] Makefile: Add option
	CONFIG_DISABLE_GCC_AUTOMATIC_INLINING
Message-ID: <20120908214359.GA18435@merkur.ravnborg.org>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2012 at 05:47:50PM -0300, Ezequiel Garcia wrote:
> As its name suggest this option prevents gcc from auto inlining
> small functions. This is very important if one wants to obtain
> traces with accurate call sites.
> 
> Without this option, gcc will collapse some small functions,
> even when not marked as 'inline' thus making impossible to
> correlate the trace caller address to the real function it belongs.
> 
> Of course, the resultant kernel is slower and slightly smaller,
> but that's not an issue if the focus is on tracing accuracy.
> 
> Cc: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
>  Makefile          |    4 ++++
>  lib/Kconfig.debug |   11 +++++++++++
>  2 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index ddf5be9..df6045a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -561,6 +561,10 @@ else
>  KBUILD_CFLAGS	+= -O2
>  endif
>  
> +ifdef CONFIG_DISABLE_GCC_AUTOMATIC_INLINING
> +KBUILD_CFLAGS	+= -fno-inline-small-functions
> +endif
> +
>  include $(srctree)/arch/$(SRCARCH)/Makefile
>  
>  ifdef CONFIG_READABLE_ASM
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 2403a63..c8fd50f 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1265,6 +1265,17 @@ config LATENCYTOP
>  source mm/Kconfig.debug
>  source kernel/trace/Kconfig
>  
> +config DISABLE_GCC_AUTOMATIC_INLINING
> +	bool "Disable gcc automatic inlining"

Could we please call this option for:
config CC_DISABLE_AUTOMATIC_INLINING

We have at least a few other options following that naming scheme.
And today we have no options named *GCC_*

	Sam
