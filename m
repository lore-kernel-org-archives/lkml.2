Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab1CWUvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:51:15 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48488 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323Ab1CWUvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AGEPSX+kMMgWhSg7JptgKdADNSPQA3XpfpPSMekS3d53QTnL3Yp4zqj/oUcA+AgMLh
         dqkTgD8zrJcG52qvyehRpY1tg69biSJAW+FwCK3u1LWaLDYvtLhrcm/TLIhAoNejKTFC
         puJjim9Xo67opIGpShMfu9fmD61sGRRaNghGw=
MIME-Version: 1.0
In-Reply-To: <1297838092-22989-4-git-send-email-johnstul@us.ibm.com>
References: <1297838092-22989-1-git-send-email-johnstul@us.ibm.com> <1297838092-22989-4-git-send-email-johnstul@us.ibm.com>
From: Matt Turner <mattst88@gmail.com>
Date: Wed, 23 Mar 2011 20:50:53 +0000
Message-ID: <AANLkTi=4NGQpacDwzVrdyTs-KAZwMvmCqSqukc4aERMS@mail.gmail.com>
Subject: Re: [PATCH 3/6] alpha: convert to clocksource_register_hz
To: John Stultz <johnstul@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 6:34 AM, John Stultz <johnstul@us.ibm.com> wrote:
> Converts alpha to use clocksource_register_hz.
>
> Patch is untested, so help from maintainers would be appreciated.
>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> CC: Richard Henderson <rth@twiddle.net>
> CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> CC: Matt Turner <mattst88@gmail.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/alpha/kernel/time.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
> index c1f3e7c..33b8110 100644
> --- a/arch/alpha/kernel/time.c
> +++ b/arch/alpha/kernel/time.c
> @@ -378,8 +378,7 @@ static struct clocksource clocksource_rpcc = {
>
>  static inline void register_rpcc_clocksource(long cycle_freq)
>  {
> -       clocksource_calc_mult_shift(&clocksource_rpcc, cycle_freq, 4);
> -       clocksource_register(&clocksource_rpcc);
> +       clocksource_register_hz(&clocksource_rpcc, cycle_freq);
>  }
>  #else /* !CONFIG_SMP */
>  static inline void register_rpcc_clocksource(long cycle_freq)
> --
> 1.7.3.2.146.gca209

Thanks, I'll apply this. Please CC: linux-alpha@vger.kernel.org for
alpha patches.

Matt
