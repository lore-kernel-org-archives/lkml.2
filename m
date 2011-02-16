Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab1BPWIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:08:12 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60319 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab1BPWIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:08:11 -0500
Date: Wed, 16 Feb 2011 15:08:05 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH OF 12/14] x86/rtc: don't register rtc if we the DT blob
Message-ID: <20110216220805.GH22837@angua.secretlab.ca>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
 <1295843342-1122-13-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295843342-1122-13-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 09:59:00AM +0530, Sebastian Andrzej Siewior wrote:
> or we might end up with two device nodes for the same hardware.
> 
> Cc: Andres Salomon <dilinger@queued.net>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

I'm okay with this one being merged via the x86 tree.

> ---
>  arch/x86/kernel/rtc.c |    3 +++
>  include/linux/of.h    |   12 ++++++++++++
>  2 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
> index 6f39cab..3f2ad26 100644
> --- a/arch/x86/kernel/rtc.c
> +++ b/arch/x86/kernel/rtc.c
> @@ -6,6 +6,7 @@
>  #include <linux/acpi.h>
>  #include <linux/bcd.h>
>  #include <linux/pnp.h>
> +#include <linux/of.h>
>  
>  #include <asm/vsyscall.h>
>  #include <asm/x86_init.h>
> @@ -236,6 +237,8 @@ static __init int add_rtc_cmos(void)
>  		}
>  	}
>  #endif
> +	if (of_have_populated_dt())
> +		return 0;
>  
>  	platform_device_register(&rtc_device);
>  	dev_info(&rtc_device.dev,
> diff --git a/include/linux/of.h b/include/linux/of.h
> index cad7cf0..016968d 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -70,6 +70,11 @@ extern struct device_node *allnodes;
>  extern struct device_node *of_chosen;
>  extern rwlock_t devtree_lock;
>  
> +static inline int of_have_populated_dt(void)
> +{
> +	return allnodes != NULL;
> +}
> +
>  static inline bool of_node_is_root(const struct device_node *node)
>  {
>  	return node && (node->parent == NULL);
> @@ -222,5 +227,12 @@ extern void of_attach_node(struct device_node *);
>  extern void of_detach_node(struct device_node *);
>  #endif
>  
> +#else
> +
> +static inline int of_have_populated_dt(void)
> +{
> +	return 0;
> +}
> +
>  #endif /* CONFIG_OF */
>  #endif /* _LINUX_OF_H */
> -- 
> 1.7.3.2
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
