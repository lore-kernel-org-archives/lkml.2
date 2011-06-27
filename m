Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481Ab1F0MPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 08:15:36 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:23443 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757854Ab1F0MOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 08:14:22 -0400
Date: Mon, 27 Jun 2011 14:14:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Thomas Reim <thomas.reim@nepomuc.de>, reimth@googlemail.com,
        Dave Airlie <airlied@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Reim <rdratlos@yahoo.co.uk>
Subject: Re: [PATCH] drm/radeon: Fix Asus M2A-VM HDMI EDID error flooding
 problem
Message-ID: <20110627141404.5031c528@endymion.delvare>
In-Reply-To: <BANLkTinz5OM+NDsZy8UqbAZRFCqVV93ZNg@mail.gmail.com>
References: <1308705639-4215-1-git-send-email-reimth@gmail.com>
	<1308866743-8066-1-git-send-email-reimth@gmail.com>
	<BANLkTi=P6rB=avMSxVkEx7JQ9d95Siw2ng@mail.gmail.com>
	<1308888133.3185.36.camel@Mark-Aurel.gas.de>
	<BANLkTinz5OM+NDsZy8UqbAZRFCqVV93ZNg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jun 2011 09:36:56 -0400, Alex Deucher wrote:
> On Fri, Jun 24, 2011 at 12:02 AM, Thomas Reim <thomas.reim@nepomuc.de> wrote:
> >> > diff --git a/drivers/gpu/drm/radeon/radeon_i2c.c b/drivers/gpu/drm/radeon/radeon_i2c.c
> >> > index 781196d..7e93cf9 100644
> >> > --- a/drivers/gpu/drm/radeon/radeon_i2c.c
> >> > +++ b/drivers/gpu/drm/radeon/radeon_i2c.c
> >> > @@ -34,7 +34,7 @@
> >> >  */
> >> >  bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
> >> >  {
> >> > -       u8 out_buf[] = { 0x0, 0x0};
> >> > +       u8 out = 0x0;
> >> >        u8 buf[2];
> >> >        int ret;
> >> >        struct i2c_msg msgs[] = {
> >> > @@ -42,7 +42,7 @@ bool radeon_ddc_probe(struct radeon_connector *radeon_connector)
> >> >                        .addr = 0x50,
> >> >                        .flags = 0,
> >> >                        .len = 1,
> >> > -                       .buf = out_buf,
> >> > +                       .buf = &out,
> >> >                },
> >> >                {
> >> >                        .addr = 0x50,
> >>
> >>
> >> The change above doesn't seem to be related.
> >
> > This was a comment from Jean who complained about the ineffective usage
> > of the i2c bus. But I can also restore the old code. What's your
> > preference?
> 
> Ah, I missed that.  Let's make that a separate patch, or fix it when
> you add support for the extended edid check.
> 
> Thanks for fixing this up.

I'll send a patch for that one, as I found it. It is indeed unrelated
to the problem, I mentioned it only to avoid the same mistake in a
newly added function.

It's a very minor cleanup / optimization, BTW.

-- 
Jean Delvare
