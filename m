Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab1FJWyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:54:38 -0400
Received: from trent.utfs.org ([194.246.123.103]:45833 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758193Ab1FJWyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:54:37 -0400
Date: Fri, 10 Jun 2011 15:54:31 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linville@tuxdriver.com, LKML <linux-kernel@vger.kernel.org>,
        linux ppc dev <linuxppc-dev@lists.ozlabs.org>, zajec5@gmail.com
Subject: Re: 3.0-rc1: powerpc hangs at Kernel virtual memory layout
In-Reply-To: <1306983467.29297.51.camel@pasglop>
Message-ID: <alpine.DEB.2.01.1106101552460.9183@trent.utfs.org>
References: <alpine.DEB.2.01.1105311644010.21697@trent.utfs.org>  <alpine.DEB.2.01.1106011712270.21697@trent.utfs.org> <1306983467.29297.51.camel@pasglop>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jun 2011 at 12:57, Benjamin Herrenschmidt wrote:
> John, care to send the patch below to Linus ASAP ? I could reproduce and
> verify it fixes it. Thanks !
> 
> ssb: pci: Don't call PCIe specific workarounds on PCI cores
> 
> Otherwise it can/will crash....

The patch did not make it into -rc2, it's not in today's git tree either, 
AFAICS. Can anyone push this, please?

Thanks,
Christian.

> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
> index 82feb34..eddf1b9 100644
> --- a/drivers/ssb/driver_pcicore.c
> +++ b/drivers/ssb/driver_pcicore.c
> @@ -540,7 +540,8 @@ void ssb_pcicore_init(struct ssb_pcicore *pc)
>  		ssb_pcicore_init_clientmode(pc);
>  
>  	/* Additional always once-executed workarounds */
> -	ssb_pcicore_serdes_workaround(pc);
> +	if (dev->id.coreid == SSB_DEV_PCIE)
> +		ssb_pcicore_serdes_workaround(pc);
>  	/* TODO: ASPM */
>  	/* TODO: Clock Request Update */
>  }
> 
-- 
BOFH excuse #312:

incompatible bit-registration operators
