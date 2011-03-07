Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1CGLoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:44:10 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46863 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab1CGLoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:44:06 -0500
Date: Mon, 7 Mar 2011 11:44:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: cliff.cai@analog.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, akpm@linux-foundation.org,
        lrg@slimlogic.co.uk
Subject: Re: [alsa-devel] [Device-drivers-devel] [PATCH] Add driver for
	Analog Devices ADAU1701 SigmaDSP
Message-ID: <20110307114400.GB1829@sirena.org.uk>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com> <AANLkTinGyn8tujw-TrLibuDuj_Xqb4_YEPfLPFUy4WdO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinGyn8tujw-TrLibuDuj_Xqb4_YEPfLPFUy4WdO@mail.gmail.com>
X-Cookie: Love is never asking why?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 06, 2011 at 09:44:49PM -0500, Mike Frysinger wrote:
> On Sun, Mar 6, 2011 at 20:11,  <cliff.cai@analog.com> wrote:

> > +static u32 adau1701_read_register(struct snd_soc_codec *codec,
> > + ?? ?? ?? u16 reg_address, u8 length)
> > +{

> this func has "u32" for ret, and you return the raw register value
> below.  but here you try returning -EIO.  shouldnt it be "int" so the
> caller can check for "< 0" ?

This is the interface we have, unfortuantely.  It's not ideal but it'd
be a complete pain to change it and the actual benefit in production is
questionable given our lack of options for dealing with them in typical
systems beyond moaning in logs.

> > +struct snd_soc_dai_driver adau1701_dai = {
> > + ?? ?? ?? .name = "ADAU1701",

> i think the standard is to use all lower case

Typically, yes.

> > +MODULE_DESCRIPTION("ASoC ADAU1701 SigmaDSP driver");
> > +MODULE_AUTHOR("Cliff Cai");
> > +MODULE_LICENSE("GPL");

> MODULE_ALIAS() ?

That's not needed for I2C devices, it's handled by MODULE_DEVICE_TABLE()
for I2C.
