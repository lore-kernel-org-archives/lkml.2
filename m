Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab0JUHyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:54:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39902 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab0JUHyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:54:22 -0400
Date: Thu, 21 Oct 2010 08:54:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "N.P.S." <napohybelskurwysynom2010@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Removal of dead code from arch/arm/*
Message-ID: <20101021075401.GC22100@n2100.arm.linux.org.uk>
References: <AANLkTim+vj_OAd22TdThuC-HSqUiDjguOHQWjyqFaq6N@mail.gmail.com> <AANLkTi=Cpq2_vV2RGcoQhrqk8xpL59AvLFPzfvTBk5Xa@mail.gmail.com> <4CBF8BDB.7090907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBF8BDB.7090907@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 02:39:55AM +0200, N.P.S. wrote:
> diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
> index 38c261f..fd30b75 100644
> --- a/arch/arm/kernel/time.c
> +++ b/arch/arm/kernel/time.c
> @@ -37,13 +37,9 @@
>   */
>  struct sys_timer *system_timer;
>
> -#if defined(CONFIG_RTC_DRV_CMOS) || defined(CONFIG_RTC_DRV_CMOS_MODULE)
> +#if defined(CONFIG_RTC_DRV_CMOS)
>  /* this needs a better home */
>  DEFINE_SPINLOCK(rtc_lock);
> -
> -#ifdef CONFIG_RTC_DRV_CMOS_MODULE
> -EXPORT_SYMBOL(rtc_lock);
> -#endif
>  #endif    /* pc-style 'CMOS' RTC support */
>
>  /* change this if you have some constant time drift */

This is wrong, and will break the build if rtc-cmos is built as a module.
