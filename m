Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab2JHOF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 10:05:26 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1205 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab2JHOFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 10:05:23 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Date: Mon, 8 Oct 2012 19:36:42 +0530
From: "Jayachandran C." <jchandra@broadcom.com>
To: "Florian Fainelli" <florian@openwrt.org>
cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "Jayachandran C" <jayachandranc@netlogicmicro.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/32 v4] MIPS: Netlogic: use ehci-platform driver
Message-ID: <20121008140641.GC30932@jayachandranc.netlogicmicro.com>
References: <1349701906-16481-1-git-send-email-florian@openwrt.org>
 <1349701906-16481-6-git-send-email-florian@openwrt.org>
MIME-Version: 1.0
In-Reply-To: <1349701906-16481-6-git-send-email-florian@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-WSS-ID: 7C6C03663PS2978763-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 03:11:19PM +0200, Florian Fainelli wrote:
> The EHCI platform driver is suitable for use by the Netlogic XLR platform
> since there is nothing specific that the EHCI XLR platform driver does.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
> Changes in v4:
> - rebased against greg's latest usb-next
> No changes in v3
> 
> Changes in v2:
> - really change driver name to "ehci-platform"
> - slightly reworded commit message
> 
>  arch/mips/netlogic/xlr/platform.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/mips/netlogic/xlr/platform.c b/arch/mips/netlogic/xlr/platform.c
> index 71b44d8..144c5c6 100644
> --- a/arch/mips/netlogic/xlr/platform.c
> +++ b/arch/mips/netlogic/xlr/platform.c
> @@ -15,6 +15,7 @@
>  #include <linux/serial_8250.h>
>  #include <linux/serial_reg.h>
>  #include <linux/i2c.h>
> +#include <linux/usb/ehci_pdriver.h>
>  
>  #include <asm/netlogic/haldefs.h>
>  #include <asm/netlogic/xlr/iomap.h>
> @@ -123,8 +124,12 @@ static u64 xls_usb_dmamask = ~(u32)0;
>  		},							\
>  	}
>  
> +static struct usb_ehci_pdata xls_usb_ehci_pdata = {
> +	.caps_offset	= 0,
> +};
> +

Do we need to initilaize static data to 0?

JC.

