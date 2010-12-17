Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab0LQD6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 22:58:12 -0500
Received: from void.printf.net ([89.145.121.20]:58648 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0LQD6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 22:58:10 -0500
Date: Fri, 17 Dec 2010 03:58:06 +0000
From: Chris Ball <cjb@laptop.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Philip Rakity <prakity@marvell.com>, Aries Lee <arieslee@jmicron.com>,
        zhangfei gao <zhangfei.gao@gmail.com>, wuqm@marvell.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc/sdhci: Enable bus-width test for JMicron
	controllers
Message-ID: <20101217035806.GB19673@void.printf.net>
References: <s5hfwtzbj8v.wl%tiwai@suse.de> <s5h7hfbnpjs.wl%tiwai@suse.de> <s5hipyuakoq.wl%tiwai@suse.de> <s5h39pxpsjt.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h39pxpsjt.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Thu, Dec 16, 2010 at 05:54:14PM +0100, Takashi Iwai wrote:
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
> 
> This is a patch to be applied after
>   "mmc: Test bus-width for old MMC devices (v2)"
> 
> and a replacement for the previous "mmc: Enable bus-width tests on
> SDHCI host" patch.  Instead of enabling all for sdhci, this one turns
> on the feature only for JMicron, just to be safer.
> 
> 
>  drivers/mmc/host/sdhci-pci.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index d2638ff..0dc905b 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -381,6 +381,8 @@ static int jmicron_probe_slot(struct sdhci_pci_slot *slot)
>  	    slot->chip->pdev->device == PCI_DEVICE_ID_JMICRON_JMB388_ESD)
>  		jmicron_enable_mmc(slot->host, 1);
>  
> +	slot->host->mmc->caps |= MMC_CAP_BUS_WIDTH_TEST;
> +
>  	return 0;
>  }
>  

Thanks, pushed to mmc-next.

(Do others on the list agree that bus-width testing should be
whitelisted per-host like this?)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
