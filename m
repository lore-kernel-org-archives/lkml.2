Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872Ab0JSKMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:12:47 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45996 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337Ab0JSKMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:12:46 -0400
Date: Tue, 19 Oct 2010 13:12:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "Balbi, Felipe" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 3/3] drivers: cleanup Kconfig stuff
Message-ID: <20101019101229.GG31170@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1287475466-8927-1-git-send-email-felipe.contreras@gmail.com>
 <1287475466-8927-4-git-send-email-felipe.contreras@gmail.com>
 <20101019081855.GI12470@legolas.emea.dhcp.ti.com>
 <AANLkTi=8=M+egdo5o6nyMOaCyMCLaZdwJF3WKFwZnbd4@mail.gmail.com>
 <20101019090149.GC31170@legolas.emea.dhcp.ti.com>
 <AANLkTimCqZsJ6eY2zk0hJNhkYJDPbYnviiZ4gadnf-bB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AANLkTimCqZsJ6eY2zk0hJNhkYJDPbYnviiZ4gadnf-bB@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 19, 2010 at 04:55:04AM -0500, Felipe Contreras wrote:
>I'm not talking about phonet, I replied to your comment regarding
>USB_GADGET_MUSB_HDRC. For me USB_GADGET_MUSB_HDRC=n USB_G_NOKIA=y
>doesn't work, but the Kconfig allows it.

I see, that's a problem for sure.

>Ok, I'll make it: depends on (NOP_USB_XCEIV || TWL4030_USB)
>
>BTW, if you want to try this:
>./scripts/kconfig/conf --defconfig=usb_defconfig arch/arm/Kconfig
>
>usb_defconfig:
>CONFIG_ARCH_OMAP=y
>CONFIG_EXPERIMENTAL=y
>CONFIG_NET=y
>CONFIG_PHONET=y
>
>CONFIG_USB=y
>CONFIG_USB_GADGET=y
>CONFIG_USB_MUSB_OTG=y
>CONFIG_USB_MUSB_HDRC=y
>CONFIG_USB_G_NOKIA=y
>
># TODO USB_MUSB_OTG should select this
>CONFIG_USB_GADGET_MUSB_HDRC=y
>
>I expect TWL4030_USB and USB_OTG to be automatically selected.

could be, but that's a board-by-board thing. It's not mandatory to have
twl4030-usb, it's mandatory to have a transceiver, not matter which one
it is.

-- 
balbi
