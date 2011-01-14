Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab1ANQTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:19:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34354 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553Ab1ANQS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:18:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FdSEG00DZxavZwOu8SotbUA5tNIzQOuBL3aophCAtUDSYqcLxGCMJrAfz4NAWRXRCF
         ++OtqF14nJSvYPbUbAk+VK1v7eZNyhAW16WNRKX/cy0eEShacM+4XQKo5B6Pqd2Naznr
         VOhFsb9v0bH9oGIgfGET3STfHl9jdaoYXLQAg=
Date: Fri, 14 Jan 2011 19:18:51 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>
Subject: Re: [RFC PATCH 2/2] power_supply: Add new LED trigger
 charging-blink-solid-full
Message-ID: <20110114161851.GA11087@oksana.dev.rtsoft.ru>
References: <1294417697-4692-1-git-send-email-anarsoul@gmail.com>
 <1294417697-4692-3-git-send-email-anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1294417697-4692-3-git-send-email-anarsoul@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 06:28:17PM +0200, Vasily Khoruzhick wrote:
> Add new trigger to power_supply LEDs. It will blink when
> battery is charging, and stay solid when battery is charged.
> It's usefull to indicate battery state when there's only one
> LED available.
> 
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>

Strange, I got neither 0/2 nor 1/2.

Anyway, I'm fine with this particular patch, but to take 1/2 via
battery-2.6.git I need Richard's Acked-by tag.

A note wrt the new LEDs API...

> ---
>  drivers/power/power_supply_leds.c |   18 ++++++++++++++++++
>  include/linux/power_supply.h      |    2 ++
>  2 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/power_supply_leds.c b/drivers/power/power_supply_leds.c
> index 031a554..b640bbf 100644
> --- a/drivers/power/power_supply_leds.c
> +++ b/drivers/power/power_supply_leds.c
> @@ -21,6 +21,7 @@
>  static void power_supply_update_bat_leds(struct power_supply *psy)
>  {
>  	union power_supply_propval status;
> +	unsigned long delay_on = 0, delay_off = 0;
[...]
> +		led_trigger_blink(psy->charging_blink_full_solid_trig,
> +			&delay_on, &delay_off);

I think it's better to allow passing NULL to led_trigger_blink()
and thus avoid delay_{on,off} dummy variables.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
