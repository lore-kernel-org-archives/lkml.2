Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab2EMSMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 14:12:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39927 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2EMSMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 14:12:22 -0400
Date: Sun, 13 May 2012 20:12:08 +0200
From: Andi Shyti <andi.shyti@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH 3/4] power_supply/MFD: twl4030_charger: Allow charger to
 control the regulator that feeds it.
Message-ID: <20120513181208.GA2641@andi>
Mail-Followup-To: NeilBrown <neilb@suse.de>,
	Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
	Anton Vorontsov <cbou@mail.ru>,
	David Woodhouse <dwmw2@infradead.org>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	Tero Kristo <t-kristo@ti.com>
References: <20120508213518.2844.95446.stgit@notabene.brown>
 <20120508214040.2844.5662.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120508214040.2844.5662.stgit@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Wed, May 09, 2012 at 07:40:40AM +1000, NeilBrown wrote:
> @@ -183,6 +186,12 @@ static int twl4030_charger_enable_usb(struct twl4030_bci *bci, bool enable)
>  			return -EACCES;
>  		}
>  
> +		/* Need to keep regulator on */
> +		if (!bci->usb_enabled) {
> +			regulator_enable(bci->usb_reg);

Should you consider here a failure case?

> +			bci->usb_enabled = 1;
> +		}
> +
>  		/* forcing the field BCIAUTOUSB (BOOT_BCI[1]) to 1 */
>  		ret = twl4030_clear_set_boot_bci(0, TWL4030_BCIAUTOUSB);
>  		if (ret < 0)
> @@ -511,6 +524,8 @@ static int __init twl4030_bci_probe(struct platform_device *pdev)
>  	bci->usb.num_properties = ARRAY_SIZE(twl4030_charger_props);
>  	bci->usb.get_property = twl4030_bci_get_property;
>  
> +	bci->usb_reg = regulator_get(bci->dev, "bci3v1");

... and here.

Andi
