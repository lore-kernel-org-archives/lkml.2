Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2G1LWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 07:22:51 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:58465 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab2G1LWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 07:22:50 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jul 2012 07:22:50 EDT
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, Imre Kaloz <kaloz@openwrt.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ixp4xx: Declare MODULE_FIRMWARE usage
References: <1343241186-103293-1-git-send-email-tim.gardner@canonical.com>
Date: Sat, 28 Jul 2012 13:12:37 +0200
In-Reply-To: <1343241186-103293-1-git-send-email-tim.gardner@canonical.com>
	(Tim Gardner's message of "Wed, 25 Jul 2012 12:33:06 -0600")
Message-ID: <m34nosi1ga.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Gardner <tim.gardner@canonical.com> writes:

> +++ b/arch/arm/mach-ixp4xx/ixp4xx_npe.c
> @@ -116,7 +116,11 @@
>  /* NPE mailbox_status value for reset */
>  #define RESET_MBOX_STAT			0x0000F0F0
>  
> -const char *npe_names[] = { "NPE-A", "NPE-B", "NPE-C" };
> +#define NPE_A_FIRMWARE "NPE-A"
> +#define NPE_B_FIRMWARE "NPE-B"
> +#define NPE_C_FIRMWARE "NPE-C"
> +
> +const char *npe_names[] = { NPE_A_FIRMWARE, NPE_B_FIRMWARE, NPE_C_FIRMWARE };
>  
>  #define print_npe(pri, npe, fmt, ...)					\
>  	printk(pri "%s: " fmt, npe_name(npe), ## __VA_ARGS__)
> @@ -724,6 +728,9 @@ module_exit(npe_cleanup_module);
>  
>  MODULE_AUTHOR("Krzysztof Halasa");
>  MODULE_LICENSE("GPL v2");
> +MODULE_FIRMWARE(NPE_A_FIRMWARE);
> +MODULE_FIRMWARE(NPE_B_FIRMWARE);
> +MODULE_FIRMWARE(NPE_C_FIRMWARE);
>  
>  EXPORT_SYMBOL(npe_names);
>  EXPORT_SYMBOL(npe_running);

This looks like a good idea, thanks.
-- 
Krzysztof Halasa
