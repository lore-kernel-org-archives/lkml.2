Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab2I2Ncd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 09:32:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43345 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab2I2NcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 09:32:07 -0400
MIME-Version: 1.0
In-Reply-To: <CABGkUugX9m=0+tGP05WhEG9Y=cyp1jZjoxULpZN3+c7Tcf1ywg@mail.gmail.com>
References: <1348433304-28320-1-git-send-email-tero.keski-valkama@neter.fi>
	<CABGkUujMCRazGy1+69SWBsS15B97rNEXWNsR4gG8D+5WyeF2jg@mail.gmail.com>
	<20120925090151.GB1247@liondog.tnic>
	<CABGkUugOvWCSfXvLW33jmntGYAAiPP9fStXbdRAozx3bEoKBOA@mail.gmail.com>
	<20120925222417.GA31780@liondog.tnic>
	<CABGkUuhte-0xUQTpehKid5jD5=pwDKNSG_2Cq7isTJkaBZKGHw@mail.gmail.com>
	<CABGkUugaB4rmE_tiyEdhTPBaXUnE=a0A4w13U+L+Ux_NGrA4Vw@mail.gmail.com>
	<CABGkUugX9m=0+tGP05WhEG9Y=cyp1jZjoxULpZN3+c7Tcf1ywg@mail.gmail.com>
Date: Sat, 29 Sep 2012 16:32:05 +0300
X-Google-Sender-Auth: pVF9grLNrDf2cMZS3qWz8ZOgovk
Message-ID: <CABGkUuhrsCmuDBRcxftZkWOtCN8Qs4huNut=rhDa8LhquwqvSQ@mail.gmail.com>
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

I dumped a working registry by booting with acpi=off kernel parameter.

<dump>
EC RAM:

00: 02 00 00 00 02 02 00 01 00 09 00 00 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 22 00 00 00 00 00 00 00 00 00 fe
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 53 41 4e 59 4f 00 00 00 00 41 53 31 30 44 33 31
a0: 00 00 00 80 c1 00 00 5f ff 10 00 0e 64 17 81 ff
b0: 00 00 00 52 53 00 00 00 00 09 00 05 00 02 11 11
c0: 13 00 c9 0f 3f ab 65 30 30 2a 30 11 c9 0f 64 1f
d0: 00 00 00 00 19 7b 9b 24 00 00 05 0a 00 00 e0 40
e0: 00 00 00 28 10 20 10 1d 10 00 00 00 00 00 00 00
f0: 43 10 00 00 03 3f 00 00 44 00 00 00 00 00 00 00

Not dumping EC IDX RAM.
</dump>

This configuration rewritten to a registry booted with normal ACPI
kernel support actually speeds up the fan automatically in a sane
manner, and it actually puts the fan to max power when the temperature
is very high, as opposed to any other hack I have tried so far.

I still need to find out what exact registry value here causes the
normal automatic fan operation.

At least in this acpi=off configuration, 0xAB := 0x0E, as opposed to
the normal kernel boot up value of 0xAB := 0x08, but of course this is
not the only difference.

-- 
Kind Regards / Ystävällisin terveisin,

Tero Keski-Valkama, MSc(Tech)

+358 (0)46 876 0485

tero.keski-valkama@neter.fi
http://www.neter.fi
