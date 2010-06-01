Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab0FARN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 13:13:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38463 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab0FARN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 13:13:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ruoOlATdloIK89yOQ7HyBEtpTXzUyIb3nXmrnxC1Ao+yDMSNbAK5x1EMKXgLYkJ5fT
         HLmb0XUJj3uciX0E5GpYd8aREhANwMpJvJhP74NNq0P0EDcz48msjEa9SiGBWIfgVhWP
         XOGofChGzWp5/avWLjR13JwTeEkClnoAVE2xE=
Date: Tue, 1 Jun 2010 19:17:10 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: schedule inside spin_lock_irqsave?
Message-ID: <20100601171710.GA5176@linux-m68k.org>
References: <20100530145240.GA21559@linux-m68k.org> <4C028336.8030704@gmail.com> <4C0284FF.4080707@gmail.com> <20100530145240.GA21559@linux-m68k.org> <4C028336.8030704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C0284FF.4080707@gmail.com> <4C028336.8030704@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 05:24:38PM +0200, Jiri Slaby wrote:

Hi,

> > came across following snippet of code (2.6.34:drivers/media/dvb/siano/smscoreapi.c) and 

...
...
...

> This should be
> wait_event(&coredev->buffer_mng_waitq, cb = get_entry());
> with get_entry like:
> struct smscore_buffer_t *get_entry(void)
> {
>   struct smscore_buffer_t *cb = NULL;
>   spin_lock_irqsave(&coredev->bufferslock, flags);
>   if (!list_empty(&coredev->buffers)) {
>     cb = (struct smscore_buffer_t *) coredev->buffers.next;
>     list_del(&cb->entry);
>   }
>   spin_unlock_irqrestore(&coredev->bufferslock, flags);
>   return cb;
> }

...
...
...


> 
> Looking at the smscore_buffer_t definition, this is really ugly since it
> relies on entry being the first in the structure. It should be
> list_first_entry(&coredev->buffers, ...) instead, cast-less.
> 
> >     list_del(&cb->entry);
> >   }
> >   spin_unlock_irqrestore(&coredev->bufferslock, flags);
> >   return cb;
> > }

thanks for the suggestions, is it on anyones TODO list or should I cook up my own patch? 
Would take a few more days till I can get at it.

BTW does anyone have knowledge how to enable IR receiver code for the smsxxx devices? 
Looks like its just the matter of setting sms_board_gpio_cfg.ir to the "right" value
- which value?

Richard
