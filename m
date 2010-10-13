Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0JMMdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:33:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44701 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754028Ab0JMMdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:33:05 -0400
Date: Wed, 13 Oct 2010 13:33:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Peter Hsiang <Peter.Hsiang@maxim-ic.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
Subject: Re: [PATCH] sound/soc: rename vol to volatile_register as
 appropriate
Message-ID: <20101013123301.GL6424@rakim.wolfsonmicro.main>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
 <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
 <1286934472.1117.129.camel@Joe-Laptop>
 <20101013082414.GD6424@rakim.wolfsonmicro.main>
 <1286971846.1117.191.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286971846.1117.191.camel@Joe-Laptop>
X-Cookie: 667:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 05:10:45AM -0700, Joe Perches wrote:
> Rename the declaration and uses of variables
> named vol to volatile_register to avoid name
> clash with the much more common use of vol
> for volume.

Are any of the contexts actually ambiguous?  I have to say I don't find
this useful.  If the register I/O code knows anything about volumes I'd
say we've probably messed up somewhere.

> > > static struct {
> > > 	bool readable;
> > > 	bool writable,
> > > 	bool vol;
> > > } etc...

> > The readable and writable fields are being used as bitmasks:

> No, they are being declared as bitmasks.
> writable is used once as bool, readable isn't used at all.

They're being used in the table initialisation.

> > | +       { 0x1F, 0x1F, 1 }, /* 03 battery voltage */

> > so this discards data which we may wish to use in future.

> It's not used as bitmask now, what use would there
> be in the future for it as a bitmask?

Examples would include validating I/O operations done by drivers, or
supporting fancy cache handling that pays attention to things per bit.

> > vol is traditionally used for this throughout the subsystem.  It's
> > unfortuante that volatile is a keyword.

> As far as I see, your description of vol being
> used throughout the subsystem is not true.

I'm sorry?  It's used as the field name for volatility in all the
drivers I can remember that use a table to look volatility up in
register properties.
