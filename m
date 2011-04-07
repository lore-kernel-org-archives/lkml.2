Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab1DGT7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 15:59:47 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13578 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889Ab1DGT7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 15:59:10 -0400
Date: Thu, 7 Apr 2011 21:59:27 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Malcolm Priestley <tvboxspy@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?ISO-8859-15?Q?David_H=E4rdeman?= <david@hardeman.nu>,
        Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH][media] DVB, USB, lmedm04: Fix firmware mem leak in
 lme_firmware_switch()
In-Reply-To: <1302206185.2846.2.camel@localhost>
Message-ID: <alpine.LNX.2.00.1104072158590.1538@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1104072142540.1538@swampdragon.chaosbits.net> <1302206185.2846.2.camel@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Apr 2011, Malcolm Priestley wrote:

> On Thu, 2011-04-07 at 21:46 +0200, Jesper Juhl wrote:
> > Don't leak 'fw' in 
> > drivers/media/dvb/dvb-usb/lmedm04.c::lme_firmware_switch() by failing to 
> > call release_firmware().
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  lmedm04.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> >  compile tested only
> > 
> > diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
> > index cd26e7c..d7cc625 100644
> > --- a/drivers/media/dvb/dvb-usb/lmedm04.c
> > +++ b/drivers/media/dvb/dvb-usb/lmedm04.c
> > @@ -799,7 +799,7 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
> >  	if (cold) {
> >  		info("FRM Changing to %s firmware", fw_lme);
> >  		lme_coldreset(udev);
> > -		return -ENODEV;
> > +		ret = -ENODEV;
> >  	}
> >  
> >  	release_firmware(fw);
> 
> This has already been fixed in this commit
> 
> http://git.linuxtv.org/media_tree.git?a=commit;h=b328817a2a391d1e879c4252cd3f11a352d3f3bc
> 
I see. Thanks. I was not aware of that.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

