Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab1DNSmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:42:35 -0400
Received: from [217.200.184.87] ([217.200.184.87]:31152 "EHLO
	fepna07-svc.tim.it" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753019Ab1DNSmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:42:32 -0400
Subject: Re: [PATCH] snd_hda_codec_realtek: enable ALC271 for Acer laptops
From: Guido Trentalancia <guido@trentalancia.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, kailang@realtek.com.tw, pshou@realtek.com.tw,
        jwoithe@physics.adelaide.edu.au
Date: Thu, 14 Apr 2011 18:59:27 +0200
In-Reply-To: <s5haaftmaja.wl%tiwai@suse.de>
References: <201104071738.p37HcSFX019185@vivaldi20.register.it>
	 <s5haaftmaja.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.0 
Content-Transfer-Encoding: 7bit
Message-ID: <1302800373.2766.37.camel@vortex>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Takashi.

On Thu, 2011-04-14 at 11:45 +0200, Takashi Iwai wrote:
> At Thu, 07 Apr 2011 19:38:27 +0200,
> Guido Trentalancia wrote:
> > 
> > This quick fix to the Realtek HD Audio driver enables configurable support for the ALC271 type commonly found on some Acer laptops (e.g. Aspire 5745G).
> > 
> > Normally, the driver would fall back to BIOS auto-probing. However, the "model=acer" parameter can be passed on the boot command line to enable such support. Otherwise, it is quite common that the internal microphone does not work.
> 
> Well, adding the quirk label is fine, but this is no real fix.
> I can apply it with a different subject.

Yes, it wasn't meant to be a definitive fix. This is because I am no
expert in that specific driver. I just bought the Acer Aspire 5745G and
found that the internal microphone was not working. So I tried to find a
quick fix and when I found it I thought other users might benefit from
it. As simple as that.

The idea was more or less to have that applied as soon as possible so
that things are not broken for that class of users and then have
somebody with more expertise in the driver to fix it in the proper way
when possible.

> Anyway, it's not such quite common that the machine doesn't work
> without the model quirk any longer :)  In most cases, we want to avoid
> the model quirk but fixing the pin configuration instead.
> 
> If the auto-parser doesn't work as is, please give alsa-info.sh output
> on your machine, and give the exact description what doesn't actually
> work.  Then we can fix in a better way.

That's fine. What is broken is the internal microphone (this was stated
somewhere in the original message). In practice, I think the pin
configuration fails (vanilla 2.6.38.2).

The rest will happen off-list.

Thanks,

Guido

> thanks,
> 
> Takashi
> 
> > --- linux-2.6.38.2-original/sound/pci/hda/patch_realtek.c	2011-04-07 17:56:25.053046707 +0200
> > +++ linux-2.6.38.2/sound/pci/hda/patch_realtek.c	2011-04-07 19:03:00.975706888 +0200
> > @@ -15028,6 +15028,7 @@ static const char * const alc269_models[
> >  	[ALC269_DMIC]			= "laptop-dmic",
> >  	[ALC269_FUJITSU]		= "fujitsu",
> >  	[ALC269_LIFEBOOK]		= "lifebook",
> > +	[ALC271_ACER]			= "acer",
> >  	[ALC269_AUTO]			= "auto",
> >  };
> >   
> > 
> 


