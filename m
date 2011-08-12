Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab1HLHor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 03:44:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38084 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab1HLHom convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 03:44:42 -0400
From: "Koyamangalath, Abhilash" <abhilash.kv@ti.com>
To: "Koyamangalath, Abhilash" <abhilash.kv@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 12 Aug 2011 13:11:17 +0530
Subject: RE: [PATCH v2] OMAP3: powerdomains: Match silicon revision to
 select the correct "core_pwrdm" definition
Thread-Topic: [PATCH v2] OMAP3: powerdomains: Match silicon revision to
 select the correct "core_pwrdm" definition
Thread-Index: AcxC5Ia8qqHHIZ8JRjCWZU++qT/tdAV3rISs
Message-ID: <FCCFB4CDC6E5564B9182F639FC3560870370A4D985@dbde02.ent.ti.com>
References: <1310730250-10920-1-git-send-email-abhilash.kv@ti.com>
In-Reply-To: <1310730250-10920-1-git-send-email-abhilash.kv@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

On Friday, July 15, 2011 5:14 PM +0530, Koyamangalath, Abhilash wrote:
________________________________________
> From: Koyamangalath, Abhilash
> Sent: Friday, July 15, 2011 5:14 PM
> To: linux-omap@vger.kernel.org
> Cc: tony@atomide.com; linux@arm.linux.org.uk; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Koyamangalath, Abhilash
> Subject: [PATCH v2] OMAP3: powerdomains: Match silicon revision to select the correct "core_pwrdm" definition
> 
> powerdomains3xxx_data.c defines core_3xxx_pre_es3_1_pwrdm and
> core_3xxx_es3_1_pwrdm to take care of differences in "core_pwrdm"
> implementations across revisions.
> However,_pwrdm_lookup("core_pwrdm") always matches the first definition for
> 3630 ES 1.1 and 1.2 which is incorrect. This patch fixes this issue by adding
> code to match silicon revision as well while looking up "core_pwrdm" in
> _pwrdm_lookup().
> core_3xxx_es3_1_pwrdm is different from core_3xxx_pre_es3_1_pwrdm in
> that the former adds hardware save-restore support for USBTLL for 3430
> ES3.1 and for 3630 ES1.1 and ES1.2.
> 
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> ---
> v2:
> * now tested on 3630 (ES1.2 and ES1.0) and 3530 (ES3.0 and ES3.1)
> * fixed checkpatch errors/warnings.
> 
>  arch/arm/mach-omap2/powerdomain.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
> index 9af0847..82a2e30 100644
> --- a/arch/arm/mach-omap2/powerdomain.c
> +++ b/arch/arm/mach-omap2/powerdomain.c
> @@ -32,6 +32,7 @@
>  #include "powerdomain.h"
>  #include "clockdomain.h"
>  #include <plat/prcm.h>
> +#include <plat/cpu.h>
> 
>  #include "pm.h"
> 
> @@ -58,6 +59,24 @@ static struct powerdomain *_pwrdm_lookup(const char *name)
> 
>         list_for_each_entry(temp_pwrdm, &pwrdm_list, node) {
>                 if (!strcmp(name, temp_pwrdm->name)) {
> +                       if (!strcmp(name, "core_pwrdm") && cpu_is_omap3630()) {
> +                               if (omap_rev() > OMAP3630_REV_ES1_0) {
> +                                       /*
> +                                        * match omap_chip info for OMAP3630
> +                                        * Rev ES1.1, ES1.2 or higher
> +                                        */
> +                                       if (!(temp_pwrdm->omap_chip.oc
> +                                               & CHIP_GE_OMAP3630ES1_1))
> +                                               continue;
> +                               } else {
> +                                       /* match omap_chip info for OMAP3630
> +                                        * Rev ES1.0
> +                                        */
> +                                       if (!(temp_pwrdm->omap_chip.oc
> +                                                & CHIP_IS_OMAP3630ES1))
> +                                               continue;
> +                               }
> +                       }
>                         pwrdm = temp_pwrdm;
>                         break;
>                 }
> --
> 1.7.1
Any comments ?

-Abhilash 