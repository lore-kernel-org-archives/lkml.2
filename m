Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab1KXSQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 13:16:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45675 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1KXSQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 13:16:05 -0500
MIME-Version: 1.0
In-Reply-To: <1322087835.12141.YahooMailClassic@web29020.mail.ird.yahoo.com>
References: <1322087835.12141.YahooMailClassic@web29020.mail.ird.yahoo.com>
Date: Thu, 24 Nov 2011 19:16:03 +0100
Message-ID: <CA+gwMcf9xvcFNJoxmDO0z-FMhKrd=9eptSDrpsBB3a20pzMfKw@mail.gmail.com>
Subject: Re: [PATCH] power/ds2760_battery: Add rated capacity of the hx4700
 3600mAh battery
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org, mad_soft@inbox.ru,
        koen@dominion.thruhere.net, cbouatmailru@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:37 PM, Paul Parsons <lost.distance@yahoo.com> wrote:
> Add rated capacity of the HP iPAQ hx4700 3.7V 3600mAh (359114-001) battery.
> For this battery the value of the rated capacity EEPROM register at 0x32 is 14;
> thus rated_capacities[14] = 3600.
>
> Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
> ---
> diff -uprN clean-3.2-rc2/drivers/power/ds2760_battery.c linux-3.2-rc2/drivers/power/ds2760_battery.c
> --- clean-3.2-rc2/drivers/power/ds2760_battery.c        2011-11-15 17:02:59.000000000 +0000
> +++ linux-3.2-rc2/drivers/power/ds2760_battery.c        2011-11-23 22:06:46.816841888 +0000
> @@ -95,7 +95,11 @@ static int rated_capacities[] = {
>        2880,   /* Samsung */
>        2880,   /* BYD */
>        2880,   /* Lishen */
> -       2880    /* NEC */
> +       2880,   /* NEC */
> +#ifdef CONFIG_MACH_H4700
> +       0,
> +       3600,   /* HP iPAQ hx4700 3.7V 3600mAh (359114-001) */
> +#endif

Is that #ifdef needed? I know there's another one a few lines up, but
I think that one is already unfortunate and there is no conflict here.

regards
Philipp
