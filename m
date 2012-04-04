Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab2DDWXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 18:23:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43784 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab2DDWXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 18:23:49 -0400
Date: Wed, 4 Apr 2012 15:23:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: rtc-linux@googlegroups.com
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH 1/2 RFC] rtc: Add ioctl to get/clear battery
 low voltage status
Message-Id: <20120404152347.2982ec50.akpm@linux-foundation.org>
In-Reply-To: <1329236025-31323-1-git-send-email-alexander.stein@systec-electronic.com>
References: <1329236025-31323-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012 17:13:44 +0100
Alexander Stein <alexander.stein@systec-electronic.com> wrote:

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
>  #define RTC_PLL_GET	_IOR('p', 0x11, struct rtc_pll_info)  /* Get PLL correction */
>  #define RTC_PLL_SET	_IOW('p', 0x12, struct rtc_pll_info)  /* Set PLL correction */
>  
> +#define RTC_VL_READ	_IOR('p', 0x13, int)	/* Voltage low detector */
> +#define RTC_VL_CLR	_IO('p', 0x14)		/* Clear voltage low information */
> +
>  /* interrupt flags */
>  #define RTC_IRQF 0x80	/* Any of the following is active */
>  #define RTC_PF 0x40	/* Periodic interrupt */

Looks good to me, but I'd like to hear from other RTC driver
maintainers, please.

Which other devices provide support for reading the batttery status,
and is the proposed interface suitable for their drivers?

