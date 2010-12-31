Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0LaMVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 07:21:48 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43444 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab0LaMVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 07:21:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OBk+ZdiKlVDYQlJJ0LQ4M3bsyiHpC1+6eZZ+2InngEZe16p2tiu5KiLtXJA/eI/VEH
         7nNd0/ufqNG+5eQryzkTi9zpSqwju44sCH8PbJWMfjb1aaZtK33jNSVBbcm7VGhJDZ1L
         MMsn/brJcHGShPWybVvmqOjWrnnd1d7eyNevc=
Subject: Re: [PATVH] media, dvb, IX2505V: Remember to free allocated memory
 in failure path (ix2505v_attach()).
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D1DB0AC.9090008@infradead.org>
References: <alpine.LNX.2.00.1012310008070.32595@swampdragon.chaosbits.net>
	 <4D1DB0AC.9090008@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 12:21:42 +0000
Message-ID: <1293798102.2986.5.camel@tvboxspy>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-31 at 08:30 -0200, Mauro Carvalho Chehab wrote:
> Em 30-12-2010 21:11, Jesper Juhl escreveu:
> > Hi,
> > 
> > We may leak the storage allocated to 'state' in 
> > drivers/media/dvb/frontends/ix2505v.c::ix2505v_attach() on error.
> > This patch makes sure we free the allocated memory in the failure case.
> > 
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  ix2505v.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> >   Compile tested only.
> > 
> > diff --git a/drivers/media/dvb/frontends/ix2505v.c b/drivers/media/dvb/frontends/ix2505v.c
> > index 55f2eba..fcb173d 100644
> > --- a/drivers/media/dvb/frontends/ix2505v.c
> > +++ b/drivers/media/dvb/frontends/ix2505v.c
> > @@ -293,6 +293,7 @@ struct dvb_frontend *ix2505v_attach(struct dvb_frontend *fe,
> >  		ret = ix2505v_read_status_reg(state);
> >  
> >  		if (ret & 0x80) {
> > +			kfree(state);
> 
> Instead of doing the free here, please move it to happen at the error: logic.
> Currently, there's just one error condition, but having part of the release/kfree
> logic here and there is not a good idea.
> 
> >  			deb_i2c("%s: No IX2505V found\n", __func__);
> >  			goto error;
> >  		}

The state is already freed in ix2505v_release on error.


