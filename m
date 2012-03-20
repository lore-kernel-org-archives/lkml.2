Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab2CTNQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:16:52 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:58344 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752334Ab2CTNQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:16:51 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 RFC] rtc: Add ioctl to get/clear battery low voltage status
Date: Tue, 20 Mar 2012 14:16:48 +0100
Message-ID: <10044051.7oD69oyPfX@ws-stein>
User-Agent: KMail/4.7.4 (Linux/3.2.1-gentoo-r2; KDE/4.7.4; x86_64; ; )
In-Reply-To: <1329236025-31323-1-git-send-email-alexander.stein@systec-electronic.com>
References: <1329236025-31323-1-git-send-email-alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any news/feedback on these patches?

Regards,
Alexander

Am Dienstag, 14. Februar 2012, 17:13:44 schrieb Alexander Stein:
> Currently there is no generic way to get the RTC battery status within
> an application. So add an ioctl to read the status bit.
> The idea is that the bit is set once a low voltage is detected. It stays
> there until it is reset using the RTC_VL_CLR ioctl.
> 
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
> ---
>  include/linux/rtc.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/rtc.h b/include/linux/rtc.h
> index 93f4d03..1a6ec5f 100644
> --- a/include/linux/rtc.h
> +++ b/include/linux/rtc.h
> @@ -91,6 +91,9 @@ struct rtc_pll_info {
>  #define RTC_PLL_GET	_IOR('p', 0x11, struct rtc_pll_info)  /* Get PLL
> correction */ #define RTC_PLL_SET	_IOW('p', 0x12, struct rtc_pll_info)  /*
> Set PLL correction */
> 
> +#define RTC_VL_READ	_IOR('p', 0x13, int)	/* Voltage low detector */
> +#define RTC_VL_CLR	_IO('p', 0x14)		/* Clear voltage low information 
*/
> +
>  /* interrupt flags */
>  #define RTC_IRQF 0x80	/* Any of the following is active */
>  #define RTC_PF 0x40	/* Periodic interrupt */
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
August-Bebel-Str. 29
D-07973 Greiz

Tel: +49-3661-6279-0, Fax: +49-3661-6279-99
eMail:    Alexander.Stein@systec-electronic.com
Internet: http://www.systec-electronic.com

Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Jena, HRB 205563
