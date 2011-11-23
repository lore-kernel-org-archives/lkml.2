Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177Ab1KWH3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 02:29:55 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:33822 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab1KWH3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 02:29:54 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rtc-cmos: fix broken NVRAM bank 2 writing
Date: Wed, 23 Nov 2011 08:29:19 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201111132320.34420.linux@rainbow-software.org> <20111122151605.827702bf.akpm@linux-foundation.org>
In-Reply-To: <20111122151605.827702bf.akpm@linux-foundation.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201111230829.20010.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 November 2011, Andrew Morton wrote:
> On Sun, 13 Nov 2011 23:20:31 +0100
>
> Ondrej Zary <linux@rainbow-software.org> wrote:
> > Fix writing to NVRAM bank 2 in rtc-cmos driver. It never worked since its
> > introduction in 2.6.28 because of a typo.
> >
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> >
> > --- linux-3.1-orig/drivers/rtc/rtc-cmos.c	2011-10-24 09:10:05.000000000
> > +0200 +++ linux-3.1/drivers/rtc/rtc-cmos.c	2011-11-08 17:43:29.000000000
> > +0100 @@ -164,7 +164,7 @@ static inline unsigned char cmos_read_ba
> >  static inline void cmos_write_bank2(unsigned char val, unsigned char
> > addr) {
> >  	outb(addr, RTC_PORT(2));
> > -	outb(val, RTC_PORT(2));
> > +	outb(val, RTC_PORT(3));
> >  }
> >
> >  #else
>
> Strange.  Can you suggest why this bug has lived for so long without anyone
> noticing it?

Probably because nobody uses it. It's hidden in sysfs 
(/sys/class/rtc/rtc0/device/nvram) and there's another (old) module "nvram" 
that does (mostly) the same thing (except there's no bank 2 support). 

-- 
Ondrej Zary
