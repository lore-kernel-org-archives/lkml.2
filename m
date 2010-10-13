Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0JMMzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:55:51 -0400
Received: from mail.perches.com ([173.55.12.10]:2852 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab0JMMzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:55:50 -0400
Subject: Re: [PATCH] sound/soc: rename vol to volatile_register as
 appropriate
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Peter Hsiang <Peter.Hsiang@maxim-ic.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
In-Reply-To: <20101013123301.GL6424@rakim.wolfsonmicro.main>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
	 <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
	 <1286934472.1117.129.camel@Joe-Laptop>
	 <20101013082414.GD6424@rakim.wolfsonmicro.main>
	 <1286971846.1117.191.camel@Joe-Laptop>
	 <20101013123301.GL6424@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 05:55:48 -0700
Message-ID: <1286974549.1117.254.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 13:33 +0100, Mark Brown wrote:
> On Wed, Oct 13, 2010 at 05:10:45AM -0700, Joe Perches wrote:
> > Rename the declaration and uses of variables
> > named vol to volatile_register to avoid name
> > clash with the much more common use of vol
> > for volume.
> Are any of the contexts actually ambiguous?  I have to say I don't find
> this useful.  If the register I/O code knows anything about volumes I'd
> say we've probably messed up somewhere.

Looking at the 2 register access routines where
volatile_register/vol is used, I'd say those
routines aren't useful at all and the checks
should be inline instead.

This sort of wrapper routine doesn't serve
much of a purpose to me:

 static int wm8904_volatile_register(unsigned int reg)
 {
-       return wm8904_access[reg].vol;
+       return wm8904_access[reg].volatile_register;
 }

> It's used as the field name for volatility in all the
> drivers I can remember that use a table to look volatility up in
> register properties.

I did a grep for vol in sound, I found the uses
where it was for volatile and patched them.

Are there others?  Perhaps, but I don't think so.
Probably not in sound.  Was there some other
subsystem you meant?  Maybe you have examples
I missed?

