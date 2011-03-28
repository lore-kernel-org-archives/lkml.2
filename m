Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab1C1QcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:32:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40102 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab1C1Qb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UZ9feEGznib/co95jGArRlk+nEHpAAJHmHsGLQaK6VH9D4CuirJKljwwwqBg5cLpOn
         gAdUSRyTGsr6y/aFOFsXb4maKHUoHk34e4mzv8TDoyeOL4fveRsbv5xfQeUFB0JbVc2l
         hVjMNgWkNxM9eI/Fx5kcr+GrIlMR9eBMLk3Y4=
Subject: Re: [PATCH v4 1/2] ata: pata_at91.c bugfix for initial_timing
 initialisation
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D90B3ED.8080608@ru.mvista.com>
References: <1301316975-27761-1-git-send-email-plyatov@gmail.com>
	 <4D90B3ED.8080608@ru.mvista.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 20:31:51 +0400
Message-ID: <1301329911.2668.3.camel@homepc>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergei!

> Hello.
> 
> Igor Plyatov wrote:
> 
> > The "struct ata_timing" must contain 10 members, but ".dmack_hold" member was
> > forgotten for "initial_timing" initialisation. This patch fixes such a problem.
> 
> > Signed-off-by: Igor Plyatov <plyatov@gmail.com>
> > ---
> >  drivers/ata/pata_at91.c |   14 ++++++++++++--
> >  1 files changed, 12 insertions(+), 2 deletions(-)
> 
> > diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
> > index 0da0dcc..0267d54 100644
> > --- a/drivers/ata/pata_at91.c
> > +++ b/drivers/ata/pata_at91.c
> > @@ -49,8 +49,18 @@ struct at91_ide_info {
> >  	void __iomem *alt_addr;
> >  };
> >  
> > -static const struct ata_timing initial_timing =
> > -	{XFER_PIO_0, 70, 290, 240, 600, 165, 150, 600, 0};
> > +static const struct ata_timing initial_timing = {
> > +	.mode		= XFER_PIO_0,
> > +	.setup		= 70,
> > +	.act8b		= 290,
> > +	.rec8b		= 240,
> > +	.cyc8b		= 600,
> > +	.active		= 165,
> > +	.recover	= 150,
> > +	.dmack_hold	= 0,
> > +	.cycle		= 600,
> > +	.udma		= 0
> > +};
> 
>    There's no need to explicitly initialize to 0.
> 
> MBR, Sergei

It's much better to explicitly initialise, then use old wrong code,
where .dmack_hold member was equal to 600.

Best regards!
--
Igor Plyatov


