Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1DESaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:30:55 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:37539
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907Ab1DESax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:30:53 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Apr 2011 14:30:52 EDT
X-SpamScore: -14
X-BigFish: VS-14(zz154dM1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 5 Apr 2011 13:15:04 -0500
From: Scott Wood <scottwood@freescale.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: <trivial@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Harninder Rai <harninder.rai@freescale.com>
Subject: Re: [RFC 2/5]arch:powerpc:sysdev:Makefile Remove unused config in
 the Makefile.
Message-ID: <20110405131504.1d182da4@schlenkerla.am.freescale.net>
In-Reply-To: <1302022702-24541-2-git-send-email-justinmattock@gmail.com>
References: <1302022702-24541-1-git-send-email-justinmattock@gmail.com>
	<1302022702-24541-2-git-send-email-justinmattock@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 09:58:19 -0700
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> The patch below removes an unused config variable found by using a kernel
> cleanup script.
> Note: I did try to cross compile these but hit erros while doing so..
> (gcc is not setup to cross compile) and am unsure if anymore needs to be done.
> Please have a look if/when anybody has free time.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: linuxppc-dev@lists.ozlabs.org
> 
> ---
>  arch/powerpc/sysdev/Makefile |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
> index 1e0c933..243b6ad 100644
> --- a/arch/powerpc/sysdev/Makefile
> +++ b/arch/powerpc/sysdev/Makefile
> @@ -18,7 +18,6 @@ obj-$(CONFIG_FSL_PMC)		+= fsl_pmc.o
>  obj-$(CONFIG_FSL_LBC)		+= fsl_lbc.o
>  obj-$(CONFIG_FSL_GTM)		+= fsl_gtm.o
>  obj-$(CONFIG_MPC8xxx_GPIO)	+= mpc8xxx_gpio.o
> -obj-$(CONFIG_FSL_85XX_CACHE_SRAM)	+= fsl_85xx_l2ctlr.o fsl_85xx_cache_sram.o
>  obj-$(CONFIG_SIMPLE_GPIO)	+= simple_gpio.o
>  obj-$(CONFIG_FSL_RIO)		+= fsl_rio.o
>  obj-$(CONFIG_TSI108_BRIDGE)	+= tsi108_pci.o tsi108_dev.o

Those files do exist, and aren't pulled in by any other means I can see.
It was introduced by commit 6db92cc9d07db9f713da8554b4bcdfc8e54ad386, whose
changelog says:
	Drivers can do the following in Kconfig to use these APIs "select
FSL_85XX_CACHE_SRAM if MPC85xx"

Now, the absence of such a kconfig option[1] is a problem, but I don't think
outright removal (labelled "trivial cleanup") is appropriate, unless nobody
fixes it after the problem is pointed out.  And if it is removed, the files
should go with it.

-Scott

[1] and of any drivers that select it, though this was added fairly
recently -- perhaps such a driver change is on its way?

