Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab0GONTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 09:19:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40004 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933228Ab0GONTN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 09:19:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oLYTzQOo4DAnT7D94x0/ClrXRwwBfX0msuIJ0r/+55/+6+GZOTvPoNzeD8Q91hLjYz
         /b9WH5+9vMrVjMDBq/pfeKgif7hp3iZcZp9mx4GetqkPEDvOIzqZvMwdBluoElcfk+Kx
         BY47mtVTBHRJ0/6ACbli6m6BH06H1c7pjMj10=
MIME-Version: 1.0
In-Reply-To: <1768dbd136598aa52607378cdc7ba7b7870ab263.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <c3c850bed3f5714f1efcfad24ad4f8bfcb6b5b54.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<1768dbd136598aa52607378cdc7ba7b7870ab263.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
Date: Thu, 15 Jul 2010 21:19:11 +0800
Message-ID: <AANLkTinnIbTK8SbGclU-Z4M9l8H8vEX952HEZCNFGeph@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH 3/5] drivers/rtc: Remove unneeded ifdef 
	CONFIG_PM
From: Wan ZongShun <mcuos.com@gmail.com>
To: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Paul Gortmaker <p_gortmaker@yahoo.com>,
        Ralf Baechle <ralf@linux-mips.org>, Chris Wright <chrisw@sous-sol.org>,
        Arnaud Patard <apatard@mandriva.com>, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/14 Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>:
> Because CONFIG_PM is a precondition to CONFIG_ACPI, the ifdef
> CONFIG_PM within ifdef CONFIG_ACPI is redundant.

If you don't have other specific tree to merge your patch,
please get Andrew's help to do this.

Acked-by: Wan ZongShun <mcuos.com@gmail.com>


>
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
> ---
>  drivers/rtc/rtc-cmos.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
> index 11b8ea2..5856167 100644
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -970,7 +970,6 @@ static inline int cmos_poweroff(struct device *dev)
>
>  #include <linux/acpi.h>
>
> -#ifdef CONFIG_PM
>  static u32 rtc_handler(void *context)
>  {
>        acpi_clear_event(ACPI_EVENT_RTC);
> @@ -999,11 +998,6 @@ static void rtc_wake_off(struct device *dev)
>  {
>        acpi_disable_event(ACPI_EVENT_RTC, 0);
>  }
> -#else
> -#define rtc_wake_setup()       do{}while(0)
> -#define rtc_wake_on            NULL
> -#define rtc_wake_off           NULL
> -#endif
>
>  /* Every ACPI platform has a mc146818 compatible "cmos rtc".  Here we find
>  * its device node and pass extra config data.  This helps its driver use
> --
> 1.7.0.4
>
> --
> You received this message because you are subscribed to "rtc-linux".
> Membership options at http://groups.google.com/group/rtc-linux .
> Please read http://groups.google.com/group/rtc-linux/web/checklist
> before submitting a driver.



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com
