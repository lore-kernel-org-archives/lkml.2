Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1LLWG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:06:59 -0500
Received: from lunge.queued.net ([173.255.254.236]:54156 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab1LLWG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:06:58 -0500
Date: Mon, 12 Dec 2011 14:06:56 -0800
From: Andres Salomon <dilinger@queued.net>
To: martin-eric.racine@iki.fi
Cc: Jens Rottmann <JRottmann@lippertembedded.de>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-geode@lists.infradead.org
Subject: Re: IRQF_TIMER | IRQF_SHARED ?
Message-ID: <20111212140656.4c5e396f@queued.net>
In-Reply-To: <CAPZXPQdOrFPVR5rQzg1+ZxhU-p9SotHNft85okunB0YmUFA2Xg@mail.gmail.com>
References: <4EE620A5.7080402@LiPPERTEmbedded.de>
	<20111212123131.502be350@queued.net>
	<CAPZXPQdOrFPVR5rQzg1+ZxhU-p9SotHNft85okunB0YmUFA2Xg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011 23:00:01 +0200
Martin-Éric Racine <martin-eric.racine@iki.fi> wrote:

> 12. joulukuuta 2011 22.31 Andres Salomon <dilinger@queued.net>
> kirjoitti:
> > On Mon, 12 Dec 2011 16:41:25 +0100
> > Jens Rottmann <JRottmann@LiPPERTEmbedded.de> wrote:
> >> one of our customers tripped over the fact that the MFGPT driver
> >> won't share its IRQ with anyone else. (MFGPT defaulted to same IRQ
> >> as audio, MFGPT driver loaded first, audio fails.) *No big deal!*
> >> They don't actually need MFGPT and will simply disable it. It just
> >> made me wonder ...
> >>
> >> Why would it be such a bad idea to use IRQF_TIMER | IRQF_SHARED
> >> (see patch below)? mfgpt_tick() already does properly return
> >> IRQ_NONE when it feels unresponsible. I tested it with either
> >> driver loaded first and it seemed to work (well, at least audio
> >> worked, don't know how to explicitly test cs5535-clockevt).
> >
> > Just loading cs5535-clockevt should start the periodic timer.  On my
> > XO-1, IRQ 7 starts firing immediately.
> 
> Could it be a good idea to inform udev maintainers of this?
> 

It *would* be nice to get it auto-loading..
