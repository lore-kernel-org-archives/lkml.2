Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2CIDgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 22:36:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:46128 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab2CIDgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 22:36:10 -0500
Message-ID: <1331264145.3105.56.camel@pasglop>
Subject: Re: [PATCH 1/2] powerpc/44x: Fix PCI MSI support for Maui APM821xx
 SoC and Bluestone board
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mai La <mla@apm.com>
Cc: Paul Mackerras <paulus@samba.org>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Tirumala R Marri <tmarri@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Michael Neuling <mikey@neuling.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, open-source-review@apm.com
Date: Fri, 09 Mar 2012 14:35:45 +1100
In-Reply-To: <1331263072-9612-1-git-send-email-mla@apm.com>
References: <1331263072-9612-1-git-send-email-mla@apm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-09 at 10:17 +0700, Mai La wrote:
> This patch consists of:
> - Enable PCI MSI as default for Bluestone board
> - Define number of MSI interrupt for Maui APM821xx SoC using in Bluestone board
> - Fix returning ENODEV as finding MSI node
> - Fix MSI physical high and low address
> - Keep MSI data logically
> 
> Signed-off-by: Mai La <mla@apm.com>
> ---

> index 7b4df37..c86231e 100644
> --- a/arch/powerpc/sysdev/Kconfig
> +++ b/arch/powerpc/sysdev/Kconfig
> @@ -20,6 +20,12 @@ config PPC_MSI_BITMAP
>  	default y if FSL_PCI
>  	default y if PPC4xx_MSI
>  
> +config PPC4xx_NR_MSI_IRQS
> +	int "Number of PCI MSI interrupts"
> +	depends on PCI_MSI && PPC4xx_MSI
> +	default "4" if !APM821xx
> +	default "8" if APM821xx
> +

 .../...

> +#define NR_MSI_IRQS CONFIG_PPC4xx_NR_MSI_IRQS

ARGH.

We asked to -NOT MAKE THIS A COMPILE TIME OPTION-

CONFIG_foo is as bad as your previous ifdef, in fact you just added a
useless config option here.

Make that number dynamic. Count the entries in the device-tree (or add
a property with the number in it, whatever you fancy the most) but make
it something detected at RUNTIME !!!!!

Ben.


