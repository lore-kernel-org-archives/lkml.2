Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1EVMnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 08:43:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45477 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1EVMnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 08:43:22 -0400
Message-ID: <4DD904B6.4010700@ru.mvista.com>
Date: Sun, 22 May 2011 16:42:30 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: Re: spitz pm: adjust messages
References: <20110521122450.GA6954@elf.ucw.cz>
In-Reply-To: <20110521122450.GA6954@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-05-2011 16:24, Pavel Machek wrote:

> Charger error is something that should be reported to the syslog; do
> it. If temperature reading fails, we do not want to charge the
> battery, anyway.

> Signed-off-by: Pavel Machek <pavel@ucw.cz>

> diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
> index 785880f..513588c 100644
> --- a/arch/arm/mach-pxa/sharpsl_pm.c
> +++ b/arch/arm/mach-pxa/sharpsl_pm.c
[...]
> @@ -513,8 +500,10 @@ static int sharpsl_check_battery_temp(void)
>   	val = get_select_val(buff);
>
>   	dev_dbg(sharpsl_pm.dev, "Temperature: %d\n", val);
> -	if (val>  sharpsl_pm.machinfo->charge_on_temp) {
> -		printk(KERN_WARNING "Not charging: temperature out of limits.\n");
> +	/* FIXME: this should catch battery read errors, but we should
> +	   probably avoid charging in<0C temperatures, too. */

    The preferred style of the multi-line comments is this:

/*
  * bla
  * bla
  */

WBR, Sergei
