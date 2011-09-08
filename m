Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab1IHKww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 06:52:52 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36975 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758223Ab1IHKwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 06:52:50 -0400
X-Sasl-enc: nK1LlMYYRtIazjtA7S4XSBbH+qPY7psgmWFuQUs6HHww 1315479169
Message-ID: <4E689E9A.8000407@ladisch.de>
Date: Thu, 08 Sep 2011 12:53:14 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, Andreas Mohr <andi@lisas.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Julia Lawall <julia@diku.dk>, Ondrej Zary <linux@rainbow-software.org>,
        Dan Carpenter <error27@gmail.com>, Joe Perches <joe@perches.com>,
        alsa-devel@alsa-project.org
Subject: Re: [RFC] [PATCH 02/62] mpu401:snd_mpu401_uart_new(): split semantic
 of irq_flags
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-3-git-send-email-yong.zhang0@gmail.com>
In-Reply-To: <1315383059-3673-3-git-send-email-yong.zhang0@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang wrote:
> Now snd_mpu401_uart_new() parameter 'irq_flags' take two role
> in it: one is the condition to request_irq and the other is
> the real irq_flags which will be transfered to request_irq().
> 
> So add another parameter 'want_irq' to take the role of the
> first one, this will make it easy to remove IRQF_DISABLED.

Please note that the irq number is also intended to pass this
information:

>   * @irq: the irq number, -1 if no interrupt for mpu
> ...
> -	if (irq >= 0 && irq_flags) {
>  		if (request_irq(irq, snd_mpu401_uart_interrupt, irq_flags,

Of course, most of snd_mpu401_uart_new()'s users get this wrong and use
0 instead of -1, relying on the irq_flags parameter only.  But if these
are fixed to use irq == -1, we get the same effect without having to
introduce another parameter.


Regards,
Clemens
