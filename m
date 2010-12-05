Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab0LELeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 06:34:36 -0500
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:41253 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab0LELed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 06:34:33 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Dec 2010 06:34:33 EST
X-Spam-ASN: 
X-Spam-Hammy: 0.000-+--H*Ad:U*dri-devel, 0.000-+--HCc:D*freedesktop.org,
	0.000-+--HCc:D*lists.freedesktop.org
X-Spam-Spammy: 0.997-1--discovery, 0.963-+--H*r:mail.ffwll.ch,
	0.867-+--H*F:D*ffwll.ch
Date: Sun, 5 Dec 2010 12:28:14 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jimmy RUBIN <jimmy.rubin@stericsson.com>,
        Dan JOHANSSON <dan.johansson@stericsson.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
Message-ID: <20101205112813.GB12542@viiv.ffwll.ch>
Mail-Followup-To: Alex Deucher <alexdeucher@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jimmy RUBIN <jimmy.rubin@stericsson.com>,
	Dan JOHANSSON <dan.johansson@stericsson.com>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local>
 <201011251747.48365.arnd@arndb.de>
 <C832F8F5D375BD43BFA11E82E0FE9FE0082586F430@EXDCVYMBSTM005.EQ1STM.local>
 <201011261224.59490.arnd@arndb.de>
 <AANLkTinSb-9=xzX3LfZVYcKiDt5Qkm=qV6CiFGUyq+fC@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinSb-9=xzX3LfZVYcKiDt5Qkm=qV6CiFGUyq+fC@mail.gmail.com>
X-Operating-System: Linux viiv 2.6.37-rc3-00243-g01b64cf 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 04, 2010 at 04:34:22PM -0500, Alex Deucher wrote:
> This doesn't seem that different from the graphics chips we support
> with kms.  I don't think it would require much work to use KMS.  One
> thing we considered, but never ended up implementing was a generic
> overlay API for KMS.  Most PC hardware still has overlays, but we
> don't use them much any more on the desktop side.  It may be
> worthwhile to design an appropriate API for them for these type of
> hardware.

Just fyi about a generic overlay api: I've looked a bit into this when
doing the intel overlay support and I think adding special overlay crtcs
that can be attached real crtcs gives a nice clean api. We could the reuse
the existing framebuffer/pageflipping api to get the buffers to the
overlay engine.

The real pain starts when we want format discovery from userspace with all
the alignement/size/layout constrains. Add in tiling support and its
almost impossible to do in a generic way. But also for kms userspace needs
to know these constrains (implemented for generic use in libkms). I favor
such an approach for overlays, too (if it ever happens) - i.e. a few
helpers in libkms that allocate an appropriate buffer for a given format
and size and returns the buffer, strides and offsets for the different
planes.

-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
