Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1L0O0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 09:26:39 -0500
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:33851 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab1L0O0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 09:26:36 -0500
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Dec 2011 09:26:36 EST
Message-ID: <4EF9D327.3070808@calxeda.com>
Date: Tue, 27 Dec 2011 08:16:07 -0600
From: Rob Herring <rob.herring@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: calxeda xgmac ethernet driver add missing
 HAS_IOMEM dependency
References: <1324994825-4197-1-git-send-email-heiko.carstens@de.ibm.com>
In-Reply-To: <1324994825-4197-1-git-send-email-heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2011 08:07 AM, Heiko Carstens wrote:
> Fix allyesconfig build on architectures without IOMEM:
> 
> drivers/net/ethernet/calxeda/xgmac.c:1800:2:
>   error: implicit declaration of function 'iounmap' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Rob Herring <rob.herring@calxeda.com>

Thanks.

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
>  drivers/net/ethernet/calxeda/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ethernet/calxeda/Kconfig b/drivers/net/ethernet/calxeda/Kconfig
> index a52e725..aba435c 100644
> --- a/drivers/net/ethernet/calxeda/Kconfig
> +++ b/drivers/net/ethernet/calxeda/Kconfig
> @@ -1,6 +1,6 @@
>  config NET_CALXEDA_XGMAC
>  	tristate "Calxeda 1G/10G XGMAC Ethernet driver"
> -
> +	depends on HAS_IOMEM
>  	select CRC32
>  	help
>  	  This is the driver for the XGMAC Ethernet IP block found on Calxeda
