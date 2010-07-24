Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0GXKb4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 06:31:56 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41151 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab0GXKby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 06:31:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xppsEQc7/g2ocHmltT68AThbT9t/FeYcJyCPGFRaU4pQdUVJi5DwCoM5pjtSzYArTd
         /sDPHnWP2BimIrlzwy8Fbw2O5TkYP1sFwEgb/QBBTwd6Fyz4chKCo7eTcZ28ER7Z9n83
         CeAbUwYKp7ZJwzkA0Wyso7dQXYy+UoxI6xgQg=
MIME-Version: 1.0
In-Reply-To: <AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com>
	<20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk>
	<AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com>
Date: Sat, 24 Jul 2010 12:31:53 +0200
Message-ID: <AANLkTimnxkn5eLRHOAs6v_TJE0hM5=dQ3OWaiQP6tPJd@mail.gmail.com>
Subject: Re: Introducing the LCD-Linux project
From: Mattia Jona-Lasinio <mattia.jona@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <triad@df.lth.se>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>, ivan.kuten@promwad.com,
        lcd-linux-users@lists.sourceforge.net,
        Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 1:38 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Thu, Jul 22, 2010 at 13:21, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Why do we need a VT102 as well ?
>>
>> If you use the existing kernel console interfaces then you don't need to
>> worry about vt102 v console or having two terminal emulations running.
>
> Indeed, the kernel already has the console abstraction.

I agree on that and at the beginning I was thinking about writing a
framebuffer driver as well.
But on the way I realized that the standard Linux console was not
exactly what I needed.
I wanted to implement some escape sequences typical of the world of
small displays, like
the generation of custom characters, backward writing or backlighting.
This would have required
a change in the standard console, and I personally wouldn't dare to do
it. I thought it would have been
better to have a separate console emulation dedicated to these small devices.
Moreover I wanted something that COULD be used as a console but not
necessarily, that is
something that could run happily in the presence of a normal monitor
as well. It seems to me, but I may be
wrong, that through the standard console system only the current
visible console is actually updated
while other consoles are just "software" updated. An external LCD
would therefore be updated
only when you "switch" to it, so it would not be possible to use it to
display diagnostics.

> I wrote a LCD console driver (for a HD44780 connected to the parallel
> port) using
> the standard console abstraction several years ago. As it used the standard
> console abstraction, it supported multiple virtual consoles and co-operated with
> the VGA text console out-of-the-box. Just use ALT-Fx to switch between different
> VCs on the LCD or on VGA.

I also wrote a very simple (and experimental) LCD console driver
using the standard Linux console and LCD-Linux. More or less it works, though
the "update" problem that I mentioned is still an issue.

> Having a bigger virtual console where the LCD follows the region
> surrounding the cursor
> is indeed a nice extension to have.

That's another point which would have required a modification at the
console level
and, as I said, I didn't want to touch at the standard console. But we
can think about
it! ;)

Regards,

Mattia
