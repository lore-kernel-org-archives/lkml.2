Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab1LTUln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 15:41:43 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58527 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1LTUlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 15:41:36 -0500
Date: Tue, 20 Dec 2011 20:40:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>, alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: Re: [PATCH v2 1/7][RESEND] ARM: OMAP1: ams-delta: register latch
	dependent devices later
Message-ID: <20111220204046.GA3354@n2100.arm.linux.org.uk>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl> <83e934adfc691b347534edb7788a67ab2e6bd7e1.1324331816.git.jkrzyszt@tis.icnet.pl> <201112200028.32947.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112200028.32947.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 12:28:32AM +0100, Janusz Krzysztofik wrote:
> diff --git a/drivers/input/serio/ams_delta_serio.c b/drivers/input/serio/ams_delta_serio.c
> index d4d08bd..56ffd7c 100644
> --- a/drivers/input/serio/ams_delta_serio.c
> +++ b/drivers/input/serio/ams_delta_serio.c
> @@ -165,6 +165,9 @@ serio:
>  	kfree(ams_delta_serio);
>  	return err;
>  }
> +#ifndef MODULE
> +late_initcall(ams_delta_serio_init);
> +#else
>  module_init(ams_delta_serio_init);
>  
>  static void __exit ams_delta_serio_exit(void)
> @@ -175,3 +178,4 @@ static void __exit ams_delta_serio_exit(void)
>  	gpio_free(AMS_DELTA_GPIO_PIN_KEYBRD_DATA);
>  }
>  module_exit(ams_delta_serio_exit);
> +#endif

It's worth noting:

#ifndef MODULE
#define late_initcall(fn)               __define_initcall("7",fn,7)
#else /* MODULE */
#define late_initcall(fn)               module_init(fn)

So really, all these ifndefs aren't required.  Just change the module_init()
to late_initcall().
