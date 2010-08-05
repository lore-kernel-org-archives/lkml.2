Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337Ab0HEVJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:09:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52991 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594Ab0HEVJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:09:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Luca Tettamanti <kronos.it@gmail.com>
Subject: Re: [PATCH 42/42] drivers/media/video/bt8xx: Adjust confusing if indentation
Date: Thu, 5 Aug 2010 23:08:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.92; x86_64; ; )
Cc: Julia Lawall <julia@diku.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1008052229390.31692@ask.diku.dk> <AANLkTi=YauQBWyZnGpuBtQpNq=Re8WUXY9mH6FSFMP+7@mail.gmail.com>
In-Reply-To: <AANLkTi=YauQBWyZnGpuBtQpNq=Re8WUXY9mH6FSFMP+7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008052308.56592.arnd@arndb.de>
X-Provags-ID: V02:K0:FRbWiH0hpRFysAv9f1nJDsCLxKcygWHJw2fN7NuDjcS
 BlH72Dhj2PnqkAHisEXelTpnX7YqLAr0umdOKaDwwmPwoK39mF
 UgDEICOBK9+bTP74kqMibtSJty1jWAMKz215WdZI+7fzHPWVpV
 cuwTDfJV/i4Q3lIqweD6YO449nYnNGve6zBUkFwCUsweWFWLcR
 9Tjn8N00cZO6d7ITat5Ww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 August 2010 22:51:12 Luca Tettamanti wrote:
> > diff --git a/drivers/media/video/bt8xx/bttv-i2c.c b/drivers/media/video/bt8xx/bttv-i2c.c
> > index 685d659..695765c 100644
> > --- a/drivers/media/video/bt8xx/bttv-i2c.c
> > +++ b/drivers/media/video/bt8xx/bttv-i2c.c
> > @@ -123,7 +123,7 @@ bttv_i2c_wait_done(struct bttv *btv)
> >        if (wait_event_interruptible_timeout(btv->i2c_queue,
> >                btv->i2c_done, msecs_to_jiffies(85)) == -ERESTARTSYS)
> >
> > -       rc = -EIO;
> > +               rc = -EIO;
> 
> I'd also remove the empty line before the indented statement, it's confusing...
> 

The entire function looks a bit weird to me. If you look at the caller,
you'll notice that -EIO is treated in the same way as if the function had
returned zero, so the entire if() clause is pointless (the wait_event_*
probably is not).

Moreover, returning -ERESTARTSYS is probably the right action here,
why else would you make the wait interruptible?

	Arnd
