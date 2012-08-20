Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab2HTTrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:47:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35425 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751671Ab2HTTrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:47:49 -0400
Date: Mon, 20 Aug 2012 15:47:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andi Kleen <andi@firstfloor.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, <greg@kroah.com>
Subject: Re: [PATCH] USB: Build usb_speed_string unconditionally
In-Reply-To: <1345491508-30966-1-git-send-email-andi@firstfloor.org>
Message-ID: <Pine.LNX.4.44L0.1208201541520.1182-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> The usb core uses usb_speed_string(). But it's only selected
> for USB_GADGET. Enable it unconditionally.

What are you talking about?  USB_COMMON isn't selected at all, but it
does get built whenever USB or USB_GAGDET is enabled.  From
drivers/usb/Kconfig:

config USB_COMMON
	tristate
	default y
	depends on USB || USB_GADGET

One could argue that USB_COMMON should never be set to M, that it
should be Y if either USB or USB_GADGET is enabled at all.  But that's 
a separate matter.

> Fixes a lot of randconfig builds.

How?

Alan Stern

> Cc: greg@kroah.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/usb/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
> index f5ed3d7..d74535b 100644
> --- a/drivers/usb/Makefile
> +++ b/drivers/usb/Makefile
> @@ -57,4 +57,4 @@ obj-$(CONFIG_USB_CHIPIDEA)	+= chipidea/
>  obj-$(CONFIG_USB_RENESAS_USBHS)	+= renesas_usbhs/
>  obj-$(CONFIG_USB_GADGET)	+= gadget/
>  
> -obj-$(CONFIG_USB_COMMON)	+= usb-common.o
> +obj-y				+= usb-common.o

