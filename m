Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1EUR1o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 13:27:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35905 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1EUR1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 13:27:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=RXSMgawXPhuXh1UeWmI1U1TNL3aTzTGFW1yIS5zXgKX71U9gWDfz9q2nvHHQQczvNE
         yvKSz/bpC6M/pNhDwn0cUD+YAsxi9s3Vc/IuEqTGGtZHyuMs4JbowmWj99dwdLQsTg+7
         oBG51BDWKcDrZ7NPTiwoiS32/KrKThXzGAukw=
From: Marek Vasut <marek.vasut@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: spitz pm: adjust messages
Date: Sat, 21 May 2011 19:27:36 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-1-amd64; KDE/4.6.1; x86_64; ; )
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org
References: <20110521122450.GA6954@elf.ucw.cz>
In-Reply-To: <20110521122450.GA6954@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105211927.36619.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 21, 2011 02:24:50 PM Pavel Machek wrote:
> Charger error is something that should be reported to the syslog; do
> it. If temperature reading fails, we do not want to charge the
> battery, anyway.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/arch/arm/mach-pxa/sharpsl_pm.c
> b/arch/arm/mach-pxa/sharpsl_pm.c index 785880f..513588c 100644
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
> +		dev_warn(sharpsl_pm.dev, "Not charging: temperature %d out of
> limits.\n", val); return -1;
>  	}

Acked-by: Marek Vasut <marek.vasut@gmail.com>
