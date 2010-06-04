Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab0FDGaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 02:30:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36469 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0FDGaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 02:30:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=qPabsQSVGhNmsYy0lrJjMmuoWsBizEaARGLMgDGZZzZTt//pg1suEi27JeHfTPwhug
         Bu3lU7LH/Flv5zNgYJUtMCFQajnFsrTuIJ7Owx2/v/ZGDPNhEW5ajWtBfGqmxm9ywja2
         WIQ3VaBCCZ7l7j7MZADfegJWm1/DRCLNLE2dQ=
MIME-Version: 1.0
In-Reply-To: <1275613325.1931.849.camel@pasglop>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	<alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	<20100603164623.GM30622@atomide.com>
	<20100603181303.GB25779@flint.arm.linux.org.uk>
	<1275613325.1931.849.camel@pasglop>
Date: Fri, 4 Jun 2010 08:30:21 +0200
X-Google-Sender-Auth: Gw2ERBFPHvwHFx_0abAw4rXiOsQ
Message-ID: <AANLkTimCXB5r5unDgcZApyO0hbCSYgNgZNV-aHrxg12E@mail.gmail.com>
Subject: Re: ARM defconfig files
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King <rmk@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 03:02, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Thu, 2010-06-03 at 19:13 +0100, Russell King wrote:
>> On Thu, Jun 03, 2010 at 07:46:23PM +0300, Tony Lindgren wrote:
>> > Compiling in multiple ARM platforms is trickier, we would have to get
>> > rid of the duplicate defines like NR_IRQS, then have some common clock
>> > framework etc. Then figure out some way to get rid of Makefile.boot.
>> > Russell probably has some other things in mind that would have to be
>> > changed to make this happen.
>
> Ok so multiple platforms in one kernel is a different subject and could

Supporting multiple platforms matters a lot to keep everything (not
just defconfigs)
under control.

Technically, on m68k we only need two defconfigs: sun3_defconfig (Sun 3 doesn't
use a Motorola MMU) and multi_defconfig (which is the logical OR of
all the other
defconfigs, and which should work on all non-Sun 3).

The reason we have the others is to ease building of platform-specific
kernels that
need less memory. I guess most of them can be (almost) regenerated from
multi_defconfig just by disabling support for the other platforms.

> warrant a different thread. However it's interesting because we do that
> quite well on powerpc :-)

So you could easily have one big common defconfig...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
