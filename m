Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1DDJZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 05:25:46 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:60363 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751200Ab1DDJZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 05:25:45 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v3] s3fb: add DDC support
Date: Mon, 4 Apr 2011 11:25:36 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Ondrej Zajicek <santiago@crfreenet.org>, linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <201104032236.18936.linux@rainbow-software.org> <20110404083316.GB9431@localhost> <20110404084200.GD28208@linux-sh.org>
In-Reply-To: <20110404084200.GD28208@linux-sh.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201104041125.36404.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 April 2011, Paul Mundt wrote:
> On Mon, Apr 04, 2011 at 10:33:16AM +0200, Ondrej Zajicek wrote:
> > On Sun, Apr 03, 2011 at 10:36:15PM +0200, Ondrej Zary wrote:
> > > Add I2C support for the DDC bus and also default mode initialization by
> > > reading monitor EDID to the s3fb driver.
> > >
> > > Tested on Trio64V+ (2 cards), Trio64V2/DX, Virge (3 cards),
> > > Virge/DX (3 cards), Virge/GX2, Trio3D/2X (4 cards), Trio3D.
> > >
> > > Will probably not work on Trio32 - my 2 cards have DDC support in BIOS
> > > that looks different from the other cards but the DDC pins on the VGA
> > > connector are not connected.
> > >
> > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> >
> > Acked-by: Ondrej Zajicek <santiago@crfreenet.org>
>
> Is there much reason to leave this optional? Or are you simply waiting
> for testing feedback from Trio32 users before default-enabling it?
>
> It would generally be nice to avoid these sorts of config options for a
> specific driver if it already is quite capable of handling the
> unsupported cases and has a reasonable fallback on defaults via the error
> path.

If the config option is not desired, I'll remove it, I don't like it either. 
Just did it like some other fb drivers do. The only reason why someone would 
want to disable DDC is probably to have I2C-less kernel.

If the EDID cannot be read (old monitor connected or DDC pins not connected 
like on Trio32 cards) or the card does not have enough memory (1280x1024 LCD 
on a 1MB card), the driver falls back to 640x480-8@60.

-- 
Ondrej Zary
