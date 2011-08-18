Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1HRLW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:22:27 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:54814 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194Ab1HRLWY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:22:24 -0400
MIME-Version: 1.0
In-Reply-To: <1313664271-694-1-git-send-email-gadiyar@ti.com>
References: <1313664271-694-1-git-send-email-gadiyar@ti.com>
Date: Thu, 18 Aug 2011 16:52:22 +0530
Message-ID: <CAP05o4J01FpphHgV5tpkFGNfTBbjhtScKjWZm4iLi3H1V=EKDQ@mail.gmail.com>
Subject: Re: [PATCH] mfd: omap-usb-host: Make TLL mode work again
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Anand Gadiyar <gadiyar@ti.com>, "Balbi, Felipe" <balbi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 4:14 PM, Anand Gadiyar <gadiyar@ti.com> wrote:
> This code section seems to have been accidentally copy pasted.
> It causes incorrect bits to be set up in the TLL_CHANNEL_CONF
> register and prevents the TLL mode from working correctly.
>
> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> Cc: Keshava Munegowda <keshava_mgowda@ti.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
> Against v3.1-rc2; tested against linux-next as of 20110817 as well.
>
> This probably needs to go to -stable as well. The original code
> by me worked fine but this was broken during the code reorganization
> Keshava did.
>
>  drivers/mfd/omap-usb-host.c |    1 -
>  1 file changed, 1 deletion(-)
>
> Index: linux-2.6/drivers/mfd/omap-usb-host.c
> ===================================================================
> --- linux-2.6.orig/drivers/mfd/omap-usb-host.c
> +++ linux-2.6/drivers/mfd/omap-usb-host.c
> @@ -676,7 +676,6 @@ static void usbhs_omap_tll_init(struct d
>                                | OMAP_TLL_CHANNEL_CONF_ULPINOBITSTUFF
>                                | OMAP_TLL_CHANNEL_CONF_ULPIDDRMODE);
>
> -                       reg |= (1 << (i + 1));
>                } else
>                        continue;

Samuel Ortiz and balbi
please ack this patch

I am going to re-base runtime pm patches on top of this patch.


Regards
keshava
