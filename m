Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab1KVXQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 18:16:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab1KVXQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 18:16:07 -0500
Date: Tue, 22 Nov 2011 15:16:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc-cmos: fix broken NVRAM bank 2 writing
Message-Id: <20111122151605.827702bf.akpm@linux-foundation.org>
In-Reply-To: <201111132320.34420.linux@rainbow-software.org>
References: <201111132320.34420.linux@rainbow-software.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Nov 2011 23:20:31 +0100
Ondrej Zary <linux@rainbow-software.org> wrote:

> Fix writing to NVRAM bank 2 in rtc-cmos driver. It never worked since its
> introduction in 2.6.28 because of a typo.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> --- linux-3.1-orig/drivers/rtc/rtc-cmos.c	2011-10-24 09:10:05.000000000 +0200
> +++ linux-3.1/drivers/rtc/rtc-cmos.c	2011-11-08 17:43:29.000000000 +0100
> @@ -164,7 +164,7 @@ static inline unsigned char cmos_read_ba
>  static inline void cmos_write_bank2(unsigned char val, unsigned char addr)
>  {
>  	outb(addr, RTC_PORT(2));
> -	outb(val, RTC_PORT(2));
> +	outb(val, RTC_PORT(3));
>  }
>  
>  #else

Strange.  Can you suggest why this bug has lived for so long without anyone
noticing it?
