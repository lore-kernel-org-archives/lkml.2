Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab2GTSVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:21:47 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41692 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab2GTSVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:21:46 -0400
Date: Fri, 20 Jul 2012 20:21:45 +0200
From: Andreas Mohr <andi@lisas.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org
Subject: Re: psmouse synaptics: "hardware appears to be different" bail out
Message-ID: <20120720182145.GA14622@rhlx01.hs-esslingen.de>
References: <20120716214453.GA14785@rhlx01.hs-esslingen.de>
 <20120716220718.GA28635@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120716220718.GA28635@core.coreip.homeip.net>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 16, 2012 at 03:07:19PM -0700, Dmitry Torokhov wrote:
> On Mon, Jul 16, 2012 at 11:44:53PM +0200, Andreas Mohr wrote:
> > Hi,
> > 
> > just found the following in dmesg after resume
> > (currently running -rc7):
> > 
> > [ 9312.672073] psmouse serio2: synaptics: hardware appears to be
> > different: id(149271-149271), model(114865-114865), caps(d04771-d04773),
> > ext(a40000-a40000).
> > 
> > Acer Aspire One A110L here.
> > 
> > Any clever thoughts about this?
> > Just thought that it might be useful to report it,
> > especially since the function (in drivers/input/mouse/synaptics.c)
> > bails out right after this check/message.
> 
> Hmm, we do not really expect the touchpad change it's caracteristics at
> all during its lifetime, so no clever ideas here... It looks like a
> single bit error, but KBC should have signalled parity error in this
> case...

OK, that might be true in fact.
I disassembled that device recently (and did quite a bit of work),
so perhaps the touchpad connection isn't as reliable as I'd want it to
be...


Problem is that now (and some other times, too) S2R resume
ended up with a dead x.org keyboard (synaptics i.e. mouse pointer
was still working fine).
Remote login was ok.

In dmesg, I found:

[   13.694115] atkbd serio0: Spurious NAK on isa0060/serio0. Some
program might be trying to access hardware directly.

and then

[ 8278.484469] atkbd serio0: Spurious ACK on isa0060/serio0. Some
program might be trying to access hardware directly.

which is the one that occurred around the time of the S2R breakage.
I then triggered a remote pm-suspend,
and after S2R keyboard WAS FINE AGAIN, with NO dmesg error logged this
time!!

Don't tell me we've got a "short intermittent hardware failure on resume
leads to final hardware unusability" issue here ;-)

Anything to gather debug information when it happens again?
Perhaps some event helper tools or some such?

Xorg.0.log does not show any keyboard / input(keyboard) lines
in the whole interesting time range (only a ton of synaptics messages).

OTOH I remember some very recent work on x.org synaptics driver resume
behaviour, maybe that was done to fix such keyboard cases...

Thanks,

Andreas Mohr
