Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab2IZUr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:47:29 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39191 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2IZUr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:47:27 -0400
MIME-Version: 1.0
In-Reply-To: <CABGkUugaB4rmE_tiyEdhTPBaXUnE=a0A4w13U+L+Ux_NGrA4Vw@mail.gmail.com>
References: <1348433304-28320-1-git-send-email-tero.keski-valkama@neter.fi>
	<CABGkUujMCRazGy1+69SWBsS15B97rNEXWNsR4gG8D+5WyeF2jg@mail.gmail.com>
	<20120925090151.GB1247@liondog.tnic>
	<CABGkUugOvWCSfXvLW33jmntGYAAiPP9fStXbdRAozx3bEoKBOA@mail.gmail.com>
	<20120925222417.GA31780@liondog.tnic>
	<CABGkUuhte-0xUQTpehKid5jD5=pwDKNSG_2Cq7isTJkaBZKGHw@mail.gmail.com>
	<CABGkUugaB4rmE_tiyEdhTPBaXUnE=a0A4w13U+L+Ux_NGrA4Vw@mail.gmail.com>
Date: Wed, 26 Sep 2012 23:47:26 +0300
X-Google-Sender-Auth: xJ8Wy4yVbTccidnHmulWcVjNWAs
Message-ID: <CABGkUugX9m=0+tGP05WhEG9Y=cyp1jZjoxULpZN3+c7Tcf1ywg@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: Added support for Acer Aspire 5755G fan control.
From: Tero Keski-Valkama <tero.keski-valkama@neter.fi>
To: Borislav Petkov <bp@alien8.de>,
        Tero Keski-Valkama <tero.keski-valkama@neter.fi>,
        linux-kernel@vger.kernel.org, peter@piie.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/26 Tero Keski-Valkama <tero.keski-valkama@neter.fi>:
> 2012/9/26 Tero Keski-Valkama <tero.keski-valkama@neter.fi>:
>
> Now I have confirmed that:
> a) In default state fan does not speed up even in temperatures above
> 90 degrees, and
> b) Now, fan provably sped up, two times, at temperature of about 77 degrees.
>
> Somehow the fan speedup has always coincided with "acer_ec.pl regs"
> command, which might be caused by:
> a) Processor warms up in that command, or
> b) Reading EC has some consequences.
>
> The above register dump differs from the default boot-up state by
> obviously registers to read, with volatile values, and:
> - Register 0xAB from original value 0x08 to 0x0E.
> - Register 0xAD from original value 0x17 to 0x1F.
> This means that some of these register changes seem to enable
> automatic BIOS fan control:
> - FAN2 0 -> 1
> - FANT 0 -> 1
> - FANU 0x7 -> 0xF
>
> I have been trying to do some web searches for these register names to
> determine their meaning, but while many people have found them, they
> have only made invalid or no documented guesses about their purpose.
>
> --
> Kind Regards / Ystävällisin terveisin,
>
> Tero Keski-Valkama, MSc(Tech)
>
> +358 (0)46 876 0485
>
> tero.keski-valkama@neter.fi
> http://www.neter.fi

The automatic fan speed up has now been confirmed under CPU stress,
without running acer_ec.pl regs, so reading the registry is not the
cause.

It seems that setting the above register values actually changes the
FAN to be BIOS controlled correctly, as opposed to the default values,
which seem to keep the fan at a constant, medium speed.

At the moment it's my best guess that FANU register change does
nothing, but this needs to be confirmed. I'll check that out at some
point. At least playing around with its different values does not seem
to have any effect whatsoever.

After checking that, the patch should probably be changed from just
continuing the default boot up status in AUTO mode, because that seems
not to be truly automatic, and use the value 0x0E instead of 0x08 for
this setting.

However, this means that people not running this module will still be
left with the non-automatic fan mode for these laptops.

-- 
Kind Regards / Ystävällisin terveisin,

Tero Keski-Valkama, MSc(Tech)

+358 (0)46 876 0485

tero.keski-valkama@neter.fi
http://www.neter.fi
