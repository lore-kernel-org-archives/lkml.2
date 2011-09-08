Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab1IHNhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:37:22 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40238 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878Ab1IHNhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:37:20 -0400
Date: Thu, 8 Sep 2011 21:37:00 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jiri Kosina <jkosina@suse.cz>, Andreas Mohr <andi@lisas.de>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Julia Lawall <julia@diku.dk>, Ondrej Zary <linux@rainbow-software.org>,
        Dan Carpenter <error27@gmail.com>, Joe Perches <joe@perches.com>,
        alsa-devel@alsa-project.org
Subject: Re: [RFC] [PATCH 02/62] mpu401:snd_mpu401_uart_new(): split
 semantic of irq_flags
Message-ID: <20110908133700.GB2310@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
 <1315383059-3673-3-git-send-email-yong.zhang0@gmail.com>
 <4E689E9A.8000407@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E689E9A.8000407@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 12:53:14PM +0200, Clemens Ladisch wrote:
> Yong Zhang wrote:
> > Now snd_mpu401_uart_new() parameter 'irq_flags' take two role
> > in it: one is the condition to request_irq and the other is
> > the real irq_flags which will be transfered to request_irq().
> > 
> > So add another parameter 'want_irq' to take the role of the
> > first one, this will make it easy to remove IRQF_DISABLED.
> 
> Please note that the irq number is also intended to pass this
> information:

Yes.

this is a bit subtle:
 * @irq: the irq number, -1 if no interrupt for mpu
    
This semantic of 'irq' is kept by the callers IMHO.

 * @irq_flags: the irq request flags (SA_XXX), 0 if irq was already reserved.

So irq_flags has other meaning--if the irq is already reserved.
Maybe my imprecise description make some kind of misunderstanding.

Seems 'irq_reserved' is more meaningful than 'want_irq', yes?

> 
> >   * @irq: the irq number, -1 if no interrupt for mpu
> > ...
> > -	if (irq >= 0 && irq_flags) {
> >  		if (request_irq(irq, snd_mpu401_uart_interrupt, irq_flags,
> 
> Of course, most of snd_mpu401_uart_new()'s users get this wrong and use
> 0 instead of -1, relying on the irq_flags parameter only.  But if these
> are fixed to use irq == -1, we get the same effect without having to
> introduce another parameter.

Hmm, precisely IRQF_DISABLED imply irq is not reserved in some caller.

BTW, I'm not familiar with mpu401, so maybe I'm missing something here.

Thanks,
Yong
