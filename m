Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab1EMHFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 03:05:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32909 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab1EMHFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 03:05:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TEcsp8sf5iOL06Xz2kGcE4nomL9pYGgmVEfPy15tjQWh4sr+XTyjyRXNCPZmNbCz/N
         dVoKoj5nEegcF9weHWlN2Ll+H5LJtsSVOzZxF0KP5BNu2G42MtahcvhJX1IKrMFGB50M
         zWBy26IyJQEWGwslQN5NHJ6HrvnTVrTOP3eNg=
MIME-Version: 1.0
In-Reply-To: <F5C24FC168F95048BB6B9E0B13EB33152BA6F5307A@DIAMANT.xi-lite.lan>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
	<20110512074421.GA2429@pengutronix.de>
	<BANLkTi=N8VNh3tPxYH8dQ0UtGpN=xSzKng@mail.gmail.com>
	<F5C24FC168F95048BB6B9E0B13EB33152BA6F5307A@DIAMANT.xi-lite.lan>
Date: Fri, 13 May 2011 09:05:17 +0200
X-Google-Sender-Auth: mrXX4S1j8gFh2jeznqCAgDb2N3Y
Message-ID: <BANLkTinMxzrPS1GsTV1+poNGTxBpUFyBiw@mail.gmail.com>
Subject: Re: RE : [PATCH 0/4] Pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Matthieu Castet <matthieu.castet@parrot.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/12 Matthieu Castet <matthieu.castet@parrot.com>:

> Enumerating all possible case will be impossible because of the number of possible cases
> (and hardware guys can be very creative).

As mentioned in the document the subsystem is not about discrete
mathematics, i.e
we have no intent on enumerating every possible mux setting, only the ones that
are relevant for your electronics at hand.

> If spi can be in  { A8, A7, A6, A5 } and
> { G4, G3, G2, G1 }, Then you can output the spi on :
> - { A8, A7, A6, A5 }
> - { A8, A7, A6, G1 }
> - { A8, A7, G2, A5 }
> [...]
> - { G4, G3, G2, A5 }
> - { G4, G3, G2, G1 }
> You have 2^4 = 16 cases

Do you use all of them in practice?

> Pin muxing is really board specific  and shouldn't be in a "generic" driver.

It is rather package (PGA/BGA etc) specific than board specific. The board
is about what of the packaging options you actually use. As
mentioned in previous discussions you can pass in the actual configuration
of the mux settings from platform data, if we have device tree we can let the
board file dts inherit a package descriptor. All of this outside the
kernel tree.

So we define the function groups for the package that will actually be used
by the devices in the board files that we have.

And my first assumption is that those really aren't that many, and my second
assumption is that you would still have to have board-specific code to handle
every individual pin somewhere under mach-xxxx and this is what we're
currently trying to get away from.

> But what you could abstract is a way to select a configuration of a pin,
> not a group of pin for the board files.

The groups of pins are used when you're muxing devices, usually these use
more than one pin. And that is why we connect them to the devices
themselves with a mapping.

You can still allocate and mux individual pins for GPIO. Are there other
single-pin usecases?

Linus Walleij
