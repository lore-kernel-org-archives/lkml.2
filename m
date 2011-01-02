Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1ABU6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 15:58:32 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45107 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751192Ab1ABU6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 15:58:31 -0500
Date: Sun, 2 Jan 2011 21:30:23 +0100
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>, yegorslists@googlemail.com,
        gregkh@suse.de
Subject: Re: zaurus bluetooth regression
Message-ID: <20110102203023.GA1545@ucw.cz>
References: <20110102204532.GA12860@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110102204532.GA12860@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> It seems this commit
> 
> commit 7a56aa45982bb87bfca98a2832b5ae782c03364a
...
> ...is responsible for my bluetooth problems on zaurus -- at least
> bisect pointed to it,  as I use 16C950-based bluetooth card, it seems
> very logical. I'll try 2.6.37-rc8 with that patch reverted...
> 

And yes, 37-rc8 with that reverted results in working bluetooth, so
yrs, that patch is responsible.

								Pavel

> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 09ef570..bc8ed4b 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -241,7 +241,7 @@ static const struct serial8250_config uart_config[] = {
>  		.fifo_size	= 128,
>  		.tx_loadsz	= 128,
>  		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
> -		.flags		= UART_CAP_FIFO,
> +		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
>  	},
>  	[PORT_16654] = {
>  		.name		= "ST16654",
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
