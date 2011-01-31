Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1AaNeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:34:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60383 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab1AaNd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:33:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t7n63PRPjASLcmpOrPpHuTtgg1R6UVmK5ksij/rOsFCGTf7pjL0bxEru2oXHC0XUKc
         mN0y5hn0l2EsTK/0L2bZUZ4d+fsZ2eYGclo4Blc4ADx7DqmmMKefoVLXP3EiRmg6bMYP
         xFEevBzqxIYlXzFCari8h2/9w+mV8puejvsFw=
Date: Mon, 31 Jan 2011 16:33:54 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 2/2] power_supply: Add new LED trigger
 charging-blink-solid-full
Message-ID: <20110131133354.GA24125@oksana.dev.rtsoft.ru>
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
> ---

Appled both patches to battery-2.6.git, thanks!

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

Changed this to 

	unsigned long delay_on = 0;
	unsigned long delay_off = 0;

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
