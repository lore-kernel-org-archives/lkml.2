Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab0G1TYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:24:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56894 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0G1TYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:24:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DgMd8mJzBweFoKyZVosCYHJPNs3iuJgMPgNItaXWS5F2Ia1uY6DPg8PO66ZIk5chxN
         +Bc9J7JQmpQfKyl8tGRXyZbDtx59RqY0Ppa4kvsSqENs/BIfaPdKajdWsu2q0UV+kxJ3
         8BmwuLGmPPbuQ322irWdp5ZN2gG26fb+YKWfg=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=LAHhHEK3vbtwefroOrpoKpUs5B5=iu5_asMp6@mail.gmail.com>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com>
	<20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk>
	<AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com>
	<AANLkTimnxkn5eLRHOAs6v_TJE0hM5=dQ3OWaiQP6tPJd@mail.gmail.com>
	<loom.20100724T155117-833@post.gmane.org>
	<AANLkTi=LAHhHEK3vbtwefroOrpoKpUs5B5=iu5_asMp6@mail.gmail.com>
Date: Wed, 28 Jul 2010 21:24:32 +0200
Message-ID: <AANLkTimHQ5DoqXikCu7=Nse16axKYYTJZEBJsSxFEH2y@mail.gmail.com>
Subject: Re: Introducing the LCD-Linux project
From: Mattia Jona-Lasinio <mattia.jona@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James Simmons <jsimmons@infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, lcd-linux-users@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 10:11 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Sat, Jul 24, 2010 at 16:43, Florian Tobias Schandinat
> <FlorianSchandinat@gmx.de> wrote:
>> Mattia Jona-Lasinio <mattia.jona <at> gmail.com> writes:
>>> Moreover I wanted something that COULD be used as a console but not
>>> necessarily, that is
>>> something that could run happily in the presence of a normal monitor
>>> as well. It seems to me, but I may be
>>> wrong, that through the standard console system only the current
>>> visible console is actually updated
>>> while other consoles are just "software" updated. An external LCD
>>> would therefore be updated
>>> only when you "switch" to it, so it would not be possible to use it to
>>> display diagnostics.
>>
>> True, that's a general problem one has when multiple framebuffers exist.
>> Therefore I'd be very happy if someone could come up with a general solution.
>
> Fixing that was (one of the) goal of the linux-console project. James?

Hmmm, the linux-console project seems to be dead. There are no file
releases after nearly ten
years and the CVS is three years old.

I downloaded your driver and explored the code a bit. Indeed there are
many similarities
with the very early stages of LCD-Linux. At the beginning I also wrote
something very close to what you did.
But then I realized that
the display management part was very much intertwined with the low
level details of the display
(parallel port, 8 bit and 4 bit and so on....),
and this made the module not so obvious to be ported to different displays.
If you abstract the display management, add a framebuffer, you realize
that basically
you get a terminal emulator (nearly) for free, with the possibility to
add custom features
typical of small displays (like custom character generation). And once
a framebuffer is added,
you can play a bit by adding a virtual display larger than the
physical one, also adding
the code to keep the cursor visible in a smart way. Basically this is
the way LCD-Linux
was born. Implementing this  in the standard Linux terminal emulation
would require
a rewrite of most of the code, which I personally would do only if
there is some interest from
the community in improving the standard Linux console, and I don't
think it is the case
looking at the age of the Linux console project. So I decided to keep
it separate.
But never say never! In the future the two consoles could merge in a
single one. ;)

Greetings,

Mattia
