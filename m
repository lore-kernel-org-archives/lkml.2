Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab1KLFmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 00:42:46 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:8554 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab1KLFmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 00:42:44 -0500
X-SpamScore: -20
X-BigFish: VS-20(zz9371K936eK542M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Gang-B34182 <B34182@freescale.com>
To: "'Paul Gortmaker'" <paul.gortmaker@windriver.com>
CC: "'linuxppc-dev@lists.ozlabs.org'" <linuxppc-dev@lists.ozlabs.org>,
        "'Alexandre.Bounine@idt.com'" <Alexandre.Bounine@idt.com>,
        "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>,
        Gala Kumar-B11780 <B11780@freescale.com>,
        Zang Roy-R61911 <r61911@freescale.com>
Subject: RE: [PATCH] fsl-rio: fix compile error
Thread-Topic: [PATCH] fsl-rio: fix compile error
Thread-Index: AQHMoHieBe28ifboSEuiOz4YKtRwK5WoNkWAgACC81A=
Date: Sat, 12 Nov 2011 05:42:41 +0000
Message-ID: <9A1C2A9ACC704641BC472A1588CE164713E5E2@039-SN1MPN1-005.039d.mgd.msft.net>
References: <1321019308-7785-1-git-send-email-Gang.Liu@freescale.com>
 <4EBD43BB.8090903@windriver.com>
In-Reply-To: <4EBD43BB.8090903@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.185]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I'm afraid srio was not enabled when you compiled.

Regards,

Liu Gang
-----Original Message-----
From: Paul Gortmaker [mailto:paul.gortmaker@windriver.com] 
Sent: Friday, November 11, 2011 11:48 PM
To: Liu Gang-B34182
Cc: linuxppc-dev@lists.ozlabs.org; Alexandre.Bounine@idt.com; akpm@linux-foundation.org; linux-kernel@vger.kernel.org; Li Yang-R58472; Gala Kumar-B11780; Zang Roy-R61911
Subject: Re: [PATCH] fsl-rio: fix compile error

On 11-11-11 08:48 AM, Liu Gang wrote:
> The "#include <linux/module.h>" was replaced by "#include <linux/export.h>"
> in the patch "powerpc: various straight conversions from module.h --> export.h".
> This will cause the following compile problem:
> arch/powerpc/sysdev/fsl_rio.c: In function 'fsl_rio_mcheck_exception':
> arch/powerpc/sysdev/fsl_rio.c:296: error: implicit declaration of function 'search_exception_tables'.
> 
> The file fsl_rio.c needs the declaration of function "search_exception_tables"
> in the header file "linux/module.h".

Thanks -- not sure why this never showed up in my builds of all the powerpc configs, _or_ the linux-next builds.  Maybe srio isn't enabled in any of them? 

In any case it looks fine to me.  Having the search_exception_tables live in module.h seems odd, but that is an independent issue for later.

I can queue this unless someone else has already done so.

Paul.

> 
> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
> ---
>  arch/powerpc/sysdev/fsl_rio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/fsl_rio.c 
> b/arch/powerpc/sysdev/fsl_rio.c index de170fd..22ffccd 100644
> --- a/arch/powerpc/sysdev/fsl_rio.c
> +++ b/arch/powerpc/sysdev/fsl_rio.c
> @@ -23,7 +23,7 @@
>   */
>  
>  #include <linux/init.h>
> -#include <linux/export.h>
> +#include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/interrupt.h>


