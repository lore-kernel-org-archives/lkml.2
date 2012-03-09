Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab2CIM1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:27:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62575 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab2CIM1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:27:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the omap_dss2 tree
Date: Fri, 9 Mar 2012 12:26:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
References: <20120308170048.f1a992bca2ca2d93fa9747bf@canb.auug.org.au> <201203091150.11294.arnd@arndb.de> <1331295269.1927.54.camel@deskari>
In-Reply-To: <1331295269.1927.54.camel@deskari>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203091226.53749.arnd@arndb.de>
X-Provags-ID: V02:K0:nNIgtGf7uNbqLxb9L/CLJ2pQtH1hYml6P9dhkGFCUnu
 wCOREuSP4Dngf3QyP/NODxUaEimVbtq73v09TrLdXSpwps+Bzl
 +JYby1ixARBm5B0S3jcGPkiC0yIPzesbfKeSrT65YnmyRw5Oi9
 GSi/p8dvlLthaeOv7nH7KM1MIWq72yoQIjYCbfymsAdT2fbL+C
 7stLqwAfblunwcuv9/7HfkjX76uMvlaFTtW5N56f4Nm+4d7FBy
 UdVfY0N6lZK5bbtkErSC5G5rFy370pH4MpTgVxkmFe46RvSiCJ
 xqqfkov0iv0j87QvG0l4ggOrrNweUk7Y6mIuOhAEfyweh71oHG
 ewWLz3S1zM8ckAAqWGO0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2012, Tomi Valkeinen wrote:
>   On Fri, 2012-03-09 at 11:50 +0000, Arnd Bergmann wrote:
> > On Friday 09 March 2012, Tomi Valkeinen wrote:
> > > On Thu, 2012-03-08 at 16:16 +0000, Arnd Bergmann wrote:
> > > > On Thursday 08 March 2012, Stephen Rothwell wrote:
> > > > > Hi all,
> > > > > 
> > > > > Today's linux-next merge of the arm-soc tree got a conflict in
> > > > > arch/arm/mach-omap1/board-palmtt.c between commit ddba6c7f7ec6 ("OMAP1:
> > > > > pass LCD config with omapfb_set_lcd_config()") from the omap_dss2 tree
> > > > > and commit 2e3ee9f45b3c ("ARM: OMAP1: Move most of plat/io.h into local
> > > > > iomap.h") from the arm-soc tree.
> > > > > 
> > > > > I fixed it up (see below) and can carry the fix as necessary.
> > > > 
> > > > Hi Stephen,
> > > > 
> > > > Thanks for fixing up all the conflicts between arm-soc and omap_dss2.
> > > > I think we should make sure they are resolved in one of the trees before
> > > > the merge window.
> > > 
> > > Do we need to? The conflicts seemed to be trivial ones, like arm-soc
> > > adds/removes something that just happens to be next to something else
> > > that I add/remove.
> > > 
> > > My understanding is that it's better to leave those conflicts than to do
> > > "trickery" to avoid them.
> > 
> > Each of the conflicts is simple enough, but I feel it's worth resolving
> > them in this case because there are a number of them. Looking at them
> > again now, it's probably ok either way -- resolving them now or letting
> > Linus take care of them.
> 
> Florian, do you have an opinion about this?
> 
> Merging omapdss tree through arm-soc would make sense for avoiding
> conflicts, because almost every merge window there are some conflicts as
> I often need to edit arch/arm files also. But I'm not sure if we have
> ever had a conflict in drivers/video.
> 
> But still, it's a video driver, and fbdev tree sounds more suited for a
> video driver.
> 
> So I don't know =). Basically it's ok for me either way also. But it
> would be nice to have a standard way of doing this, instead of, for
> example, merging omapdss sometimes through fbdev, sometimes through
> arm-soc, depending on the conflicts...

Actually, I did not suggest omapdss through arm-soc, the idea was that
that the same branch gets merged into both the fbdev and the arm-soc
trees and let the fbdev tree go to Linus first.

	Arnd
