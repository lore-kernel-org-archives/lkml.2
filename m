Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab2IQUxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:53:47 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:44139 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754924Ab2IQUxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:53:46 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19lRxOdn2z3vwF9obDCIVqj
Date: Mon, 17 Sep 2012 13:53:38 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the staging
 tree
Message-ID: <20120917205338.GA11762@atomide.com>
References: <20120917192005.ab08c24f98010107fa855edf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917192005.ab08c24f98010107fa855edf@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [120917 02:21]:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/staging/tidspbridge/core/wdt.c between commit c37a1747acbf
> ("staging: tidspbridge: Prepare for irqs.h removal") from the  tree and
> commit ec2c0825ca31 ("ARM: OMAP2+: Remove hardcoded IRQs and enable
> SPARSE_IRQ") from the arm-soc tree.
> 
> I fixed it up (I guess - see below) and can carry the fix as necessary
> (no action is required).

Yes thanks again. This is the right fix for now, eventually
the numbers should come from platform data or device tree..

Regards,

Tony
 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/staging/tidspbridge/core/wdt.c
> index 1ed1474,453ef74..0000000
> --- a/drivers/staging/tidspbridge/core/wdt.c
> +++ b/drivers/staging/tidspbridge/core/wdt.c
> @@@ -25,8 -25,7 +25,8 @@@
>   #include <dspbridge/host_os.h>
>   
>   
>  +#define OMAP34XX_WDT3_BASE 		(0x49000000 + 0x30000)
> - #define INT_34XX_WDT3_IRQ 		36
> + #define INT_34XX_WDT3_IRQ 		(36 + NR_IRQS)
>   
>   static struct dsp_wdt_setting dsp_wdt;
>   


