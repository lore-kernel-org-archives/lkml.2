Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab1EZNtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:49:46 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48506 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751004Ab1EZNtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:49:45 -0400
Date: Thu, 26 May 2011 13:49:32 +0000
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: Re: spitz pm: adjust messages
Message-ID: <20110526134931.GA16958@localhost.ucw.cz>
References: <20110521122450.GA6954@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110521122450.GA6954@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric, it should probably be you merging this and surrounding
patches... Any comments? Merge?
							Pavel

On Sat 2011-05-21 14:24:50, Pavel Machek wrote:
> Charger error is something that should be reported to the syslog; do
> it. If temperature reading fails, we do not want to charge the
> battery, anyway.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
> index 785880f..513588c 100644
> --- a/arch/arm/mach-pxa/sharpsl_pm.c
> +++ b/arch/arm/mach-pxa/sharpsl_pm.c
> @@ -317,6 +302,8 @@ static void sharpsl_charge_off(void)
>  
>  static void sharpsl_charge_error(void)
>  {
> +	dev_warn(sharpsl_pm.dev, "Charger Error\n");
> +
>  	sharpsl_pm_led(SHARPSL_LED_ERROR);
>  	sharpsl_pm.machinfo->charge(0);
>  	sharpsl_pm.charge_mode = CHRG_ERROR;
> @@ -513,8 +500,10 @@ static int sharpsl_check_battery_temp(void)
>  	val = get_select_val(buff);
>  
>  	dev_dbg(sharpsl_pm.dev, "Temperature: %d\n", val);
> -	if (val > sharpsl_pm.machinfo->charge_on_temp) {
> -		printk(KERN_WARNING "Not charging: temperature out of limits.\n");
> +	/* FIXME: this should catch battery read errors, but we should
> +	   probably avoid charging in <0C temperatures, too. */
> +	if ((val < 0) || (val > sharpsl_pm.machinfo->charge_on_temp)) {
> +		dev_warn(sharpsl_pm.dev, "Not charging: temperature %d out of limits.\n", val);
>  		return -1;
>  	}
>  
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
