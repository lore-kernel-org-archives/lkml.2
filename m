Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab1D0PRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:17:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40137 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab1D0PRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:17:08 -0400
Message-ID: <4DB832FB.8030805@ru.mvista.com>
Date: Wed, 27 Apr 2011 19:15:07 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] echi: remove structure packing from ehci_def
References: <1303914841-6379-1-git-send-email-rabin@rab.in>
In-Reply-To: <1303914841-6379-1-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Rabin Vincent wrote:

> As pointed out by Arnd Bergmann, in include/linux/usb/ehci_def.h, struct
> ehci_caps is defined with __attribute__((packed)) for no good reason,

    You're talking only of one structure here, yet you're changing several...

> and this triggers undefined behaviour when using ARM's readl() on
> pointers to elements of this structure:

> http://lkml.kernel.org/r/201102021700.20683.arnd@arndb.de

> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  include/linux/usb/ehci_def.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

> diff --git a/include/linux/usb/ehci_def.h b/include/linux/usb/ehci_def.h
> index e49dfd4..7879943 100644
> --- a/include/linux/usb/ehci_def.h
> +++ b/include/linux/usb/ehci_def.h
> @@ -52,7 +52,7 @@ struct ehci_caps {
>  #define HCC_PGM_FRAMELISTLEN(p) ((p)&(1 << 1))  /* true: periodic_size changes*/
>  #define HCC_64BIT_ADDR(p)       ((p)&(1))       /* true: can use 64-bit addr */
>  	u8		portroute[8];	 /* nibbles for routing - offset 0xC */
> -} __attribute__ ((packed));
> +};
>  
>  
>  /* Section 2.3 Host Controller Operational Registers */
> @@ -150,7 +150,7 @@ struct ehci_regs {
>  #define PORT_CSC	(1<<1)		/* connect status change */
>  #define PORT_CONNECT	(1<<0)		/* device connected */
>  #define PORT_RWC_BITS   (PORT_CSC | PORT_PEC | PORT_OCC)
> -} __attribute__ ((packed));
> +};
>  
>  #define USBMODE		0x68		/* USB Device mode */
>  #define USBMODE_SDIS	(1<<3)		/* Stream disable */
> @@ -194,7 +194,7 @@ struct ehci_dbg_port {
>  	u32	data47;
>  	u32	address;
>  #define DBGP_EPADDR(dev, ep)	(((dev)<<8)|(ep))
> -} __attribute__ ((packed));
> +};
>  
>  #ifdef CONFIG_EARLY_PRINTK_DBGP
>  #include <linux/init.h>

WBR, Sergei
