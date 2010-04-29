Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865Ab0D3RjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:39:17 -0400
Received: from kroah.org ([198.145.64.141]:37865 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069Ab0D3Rid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:38:33 -0400
Date: Thu, 29 Apr 2010 15:15:29 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 3/8] USB: gadget: __init and __exit tags removed
Message-ID: <20100429221529.GA16465@kroah.com>
References: <cover.1270835924.git.mina86@mina86.com>
 <3baf39971e1f49e98498f5d00e21df4302396252.1270835924.git.mina86@mina86.com>
 <e6cbed26355492a8cde57973da56bccbb55b85a1.1270835924.git.mina86@mina86.com>
 <aa83c43874f8aa490300d6bd03472646f2727eb1.1270835924.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa83c43874f8aa490300d6bd03472646f2727eb1.1270835924.git.mina86@mina86.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 09:21:20PM +0200, Michal Nazarewicz wrote:
> __init, __initdata and __exit tags have have been removed from
> various files to make it possible for gadgets that do not use
> the __init/__exit tags to use those.
> 
> Files in question are related to:
> * the core composite framework,
> * the mass storage function (fixing a section mismatch) and
> * ethernet driver (ACM, ECM, RNDIS).
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/usb/gadget/composite.c      |   21 ++++++++++-----------
>  drivers/usb/gadget/config.c         |    4 ++--
>  drivers/usb/gadget/epautoconf.c     |   12 ++++++------
>  drivers/usb/gadget/f_acm.c          |   32 ++++++++++++++++----------------
>  drivers/usb/gadget/f_ecm.c          |   33 +++++++++++++++++----------------
>  drivers/usb/gadget/f_mass_storage.c |    2 +-
>  drivers/usb/gadget/f_rndis.c        |   34 ++++++++++++++++++----------------
>  drivers/usb/gadget/u_ether.c        |    4 ++--
>  8 files changed, 72 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index 09289bb..ff155ca 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -85,7 +85,7 @@ MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");
>   * This function returns the value of the function's bind(), which is
>   * zero for success else a negative errno value.
>   */
> -int __init usb_add_function(struct usb_configuration *config,
> +int __cold usb_add_function(struct usb_configuration *config,

What is the "__cold" for?

thanks,

greg k-h
