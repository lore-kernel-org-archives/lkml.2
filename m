Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042Ab2DYLd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:33:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33308 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866Ab2DYLdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:33:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120425073310.20124.15112.stgit@notabene.brown>
References: <20120425072931.20124.56635.stgit@notabene.brown>
	<20120425073310.20124.15112.stgit@notabene.brown>
Date: Wed, 25 Apr 2012 14:33:25 +0300
Message-ID: <CANOLnOO2kkyPUrRJiF-EX6NddG746gWvJ_fZrZPr0TC6DkbH9g@mail.gmail.com>
Subject: Re: [PATCH 3/6] twl4030_charger: allow charging whenever VBUS is present.
From: Grazvydas Ignotas <notasas@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:33 AM, NeilBrown <neilb@suse.de> wrote:
> We currently refuse to charge if the USB ID pin is grounded, even
> though VBUS might be present.
> However some chargers do pull the ID pin low through a resistor which
> might be as low as 47Kohm (openmoko charger).
>
> The documentation is unclear but some experimental evidence suggests
> that when the charge pump provides VBUS that doesn't get reflected in
> HW_CONDITIONS, so we should be safe to ignore the ID pin.

On pandora I see the opposite, STS_VBUS is set regardless of who
drives it, so this will break pandora..

>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>
>  drivers/power/twl4030_charger.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
> index 0511610..684662a 100644
> --- a/drivers/power/twl4030_charger.c
> +++ b/drivers/power/twl4030_charger.c
> @@ -155,11 +155,7 @@ static int twl4030_bci_have_vbus(struct twl4030_bci *bci)
>
>        dev_dbg(bci->dev, "check_vbus: HW_CONDITIONS %02x\n", hwsts);
>
> -       /* in case we also have STS_USB_ID, VBUS is driven by TWL itself */
> -       if ((hwsts & TWL4030_STS_VBUS) && !(hwsts & TWL4030_STS_USB_ID))
> -               return 1;
> -
> -       return 0;
> +       return (hwsts & TWL4030_STS_VBUS);
>  }
>
>  /*
>
>


-- 
Gražvydas
