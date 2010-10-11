Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0JKMAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 08:00:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47529 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753063Ab0JKMAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 08:00:17 -0400
Date: Mon, 11 Oct 2010 13:00:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: wm8804: fix error handling code
Message-ID: <20101011120014.GJ9231@rakim.wolfsonmicro.main>
References: <1286731745-18169-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286731745-18169-1-git-send-email-segooon@gmail.com>
X-Cookie: Help a swallow land at Capistrano.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 09:29:04PM +0400, Vasiliy Kulikov wrote:
> kzalloc() returns NULL on error, not ERR_PTR().
> Also wm8804_modinit() didn't called i2c_del_driver() if
> spi_register_driver() failed.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Please try to follow Documentation/SubmittingPatches - in particular,
you should always split unrelated changes into separate patches.  In
this case your I2C and kzalloc() changes have nothing to do with each
other and so should be in separate patches, and the kzalloc() changes
were already applied from a patch by someone else.  For the registration
changes...

> @@ -804,6 +804,7 @@ static int __init wm8804_modinit(void)
>  	if (ret) {
>  		printk(KERN_ERR "Failed to register wm8804 I2C driver: %d\n",
>  		       ret);
> +		goto err;
>  	}
>  #endif
>  #if defined(CONFIG_SPI_MASTER)

...it's not clear to me that this change is an improvement - it'll make
the driver more fragile in the face of errors, I don't see a benefit in
refusing to register the variant for one bus if the other fails?
