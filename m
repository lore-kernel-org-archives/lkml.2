Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab0HXITx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:19:53 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:29376 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab0HXITv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:19:51 -0400
Message-ID: <4C73807F.4090007@atmel.com>
Date: Tue, 24 Aug 2010 10:19:11 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.11) Gecko/20100711 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bn@niasdigital.com, ryan@bluewatersys.com, avictor.za@gmail.com
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
References: <30193.50267.qm@web180305.mail.gq1.yahoo.com>
In-Reply-To: <30193.50267.qm@web180305.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 23/08/2010 18:36, David Brownell :
> 
> 
> --- On Mon, 8/23/10, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
>> From: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Subject: [PATCH] pio: add arch specific gpio_is_valid() function
> 
> What's the rationale?  It's valid or not.  And there's already a
> function whose job it is to report that status ... which is set up
> for arch customization.

How do you customize it? I would like to keep the benefit of gpiolib
implementation.
In arch/arm/mach-at91/include/mach/gpio.h we include the
asm-generic/gpio.h. That is why I protect the generic code with
__HAVE_ARCH_GPIO_IS_VALID.

With this, we can keep the benefit of having an inline function.

>  Which ISTR worked fine for AT91 (among other
> platforms) ...

Well the standard function:
return ((unsigned)number) < ARCH_NR_GPIOS;
is not suitable for AT91 as said in the thread.

Best regards,
-- 
Nicolas Ferre

