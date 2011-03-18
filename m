Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1CRO0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 10:26:44 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46116 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab1CRO0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 10:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=rSMgp4R2pl9yrOSWd2/rvOFe0JL/QCxiagGb+tFc6Y2FjIyKB1tsrwDYvmDySDCqXv
         98v2r6LTnCDicmUAmsZYSmM7cmSUy+8kyp1cPHgLRdNsHdI94Xbg1JTOkNeIMZKhIjkd
         eu9m8OU5y/qtHzETRj9WdLlKvM+mDhAWOo+So=
Date: Fri, 18 Mar 2011 22:26:22 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: john.stultz@linaro.org, linux-kernel@vger.kernel.org, stable@kernel.org,
        rtc-linux@googlegroups.com, a.zummo@towertech.it
Subject: Re: [PATCH] rtc-bfin: add missing "return 0" in new alarm func
Message-ID: <20110318142618.GA3142@gmail.com>
Mail-Followup-To: Mike Frysinger <vapier@gentoo.org>,
	john.stultz@linaro.org, linux-kernel@vger.kernel.org,
	stable@kernel.org, rtc-linux@googlegroups.com, a.zummo@towertech.it
References: <1300436784-26543-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300436784-26543-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 04:26:24AM -0400, Mike Frysinger wrote:
> The new bfin_rtc_alarm_irq_enable function forgot to add a "return 0" to
> the end leading to the build warning:
> 	drivers/rtc/rtc-bfin.c: In function 'bfin_rtc_alarm_irq_enable':
> 	drivers/rtc/rtc-bfin.c:253: warning: control reaches end of non-void function
Hi Mike,
   I am sure we should give a return-value
but whether it is '0'? Maybe it should return
other value.
   Can you give some explanations for yours.

   Thanks.
   Best Regards.
   Harry Wei.
> 
> CC: stable@kernel.org
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  drivers/rtc/rtc-bfin.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
> index 17971d9..0e61e2d 100644
> --- a/drivers/rtc/rtc-bfin.c
> +++ b/drivers/rtc/rtc-bfin.c
> @@ -276,6 +276,8 @@ static int bfin_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
>  		bfin_rtc_int_set_alarm(rtc);
>  	else
>  		bfin_rtc_int_clear(~(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
> +
> +	return 0;
>  }
>  
>  static int bfin_rtc_read_time(struct device *dev, struct rtc_time *tm)
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
