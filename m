Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab1FXNgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:36:33 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:48613 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756241Ab1FXNgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:36:31 -0400
Date: Fri, 24 Jun 2011 14:36:23 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] SOUND: Fix non-ISA_DMA_API build failure
Message-ID: <20110624133623.GA32018@linux-mips.org>
References: <20110623144750.GA10180@linux-mips.org>
 <201106241519.44425.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201106241519.44425.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 03:19:44PM +0200, Arnd Bergmann wrote:

> > The sole ISA sound driver that does not use the ISA DMA API is the Adlib
> > driver so replaced the dependency of SND_ISA on ISA_DMA_API and add it to
> > each of the drivers individually.
> 
> Do we really care all that much about the Adlib driver on platforms without
> ISA_DMA_API? Right now all of sound/isa/ is hidden behind ISA_DMA_API and
> I think that's acceptable

When looking into this build error I started untangling the mess from the
isa from the sounds end and found the media bits as the root cause after I
finished the sound bits.  I honestly don't care about the Adlib - until I
plug an Adlib into one of my SGI Indigo² and that's unlikely to happen :)

> > diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> > index e4c97fd..0aeed28 100644
> > --- a/drivers/media/radio/Kconfig
> > +++ b/drivers/media/radio/Kconfig
> > @@ -168,7 +168,7 @@ config RADIO_MAXIRADIO
> >  
> >  config RADIO_MIROPCM20
> >         tristate "miroSOUND PCM20 radio"
> > -       depends on ISA && VIDEO_V4L2 && SND
> > +       depends on ISA && ISA_DMA_API && VIDEO_V4L2 && SND
> >         select SND_ISA
> >         select SND_MIRO
> >         ---help---
> 
> Then this hunk by itself would be enough to solve the compile
> errors, AFAICT.

It is, I've tested that.

  Ralf
