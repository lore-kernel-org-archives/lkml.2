Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab1KNDrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 22:47:21 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:15200 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab1KNDrU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 22:47:20 -0500
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzzz2dh2a8h668h839h93fh62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 14 Nov 2011 11:59:09 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 3/8] of: create of_phandle_args to simplify return of
 phandle parsing data
Message-ID: <20111114035908.GA10236@S2100-06.ap.freescale.net>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
 <1320801583-12774-4-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1320801583-12774-4-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Tue, Nov 08, 2011 at 06:19:38PM -0700, Grant Likely wrote:
[...]
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 4948552..566deab 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -222,6 +222,13 @@ extern const void *of_get_property(const struct device_node *node,
>  #define for_each_property(pp, properties) \
>  	for (pp = properties; pp != NULL; pp = pp->next)
>  
> +#define MAX_PHANDLE_ARGS 8
> +struct of_phandle_args {
> +	struct device_node *np;
> +	int args_count;
> +	uint32_t args[MAX_PHANDLE_ARGS];
> +};
> +

I'm seeing a bunch of warnings like the one below when compiling imx
with the series.  And moving the definition to somewhere before
'#include <asm/prom.h>' in linux/of.h removes the warnings for me.

  CC      arch/arm/kernel/devtree.o
In file included from arch/arm/plat-mxc/include/mach/irqs.h:14:0,
                 from arch/arm/include/asm/irq.h:4,
                 from arch/arm/include/asm/prom.h:17,
                 from include/linux/of.h:133,
                 from arch/arm/kernel/devtree.c:17:
include/asm-generic/gpio.h:133:24: warning: ‘struct of_phandle_args’ declared inside parameter list
include/asm-generic/gpio.h:133:24: warning: its scope is only this definition or declaration, which is probably not what you want

-- 
Regards,
Shawn

