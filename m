Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2JNLEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 07:04:24 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:53647 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2JNLEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 07:04:23 -0400
Date: Sun, 14 Oct 2012 13:03:23 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: dmarkh@cfl.rr.com
Cc: markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Intel graphics drm issue?
Message-ID: <20121014130323.06f0225d@neptune.home>
In-Reply-To: <507A997D.7070508@cfl.rr.com>
References: <507812E8.3060607@compro.net>
	<20121012231459.166e29fd@neptune.home>
	<5079B97C.7020401@cfl.rr.com>
	<5079BE5C.8020401@cfl.rr.com>
	<20121014104138.7e8a9c59@neptune.home>
	<507A997D.7070508@cfl.rr.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 October 2012 Mark Hounschell <dmarkh@cfl.rr.com> wrote:
> On 10/14/2012 04:41 AM, Bruno Prémont wrote:
> > Your best solution is probably to write an EDID blob (or reuse one you find
> > somewhere) that provides at least one mode matching your TV's native mode
> > (probably full-HD).
> >
> > Google suggested the following document:
> > http://www.jordansmanuals.com/ServiceManuals%5CLG%5CTV%5CLCD%5C42LB9DF%5C42LB9DF%20Service%20Manual.pdf
> > which on page 13/14 shows the full EDID blob for the various HDMI outputs of the
> > TV. You may want to read that document, convert the EDID blobs to 512 bytes binary
> > files and hell DRM core to use the right one via module/kernel cmdline option:
> >
> >   drm_kms_helper.edid_firmware=edid/lg42lb9df.edid
> > or
> >   modprobe drm-kms-helper edid_firmware=edid/lg42lb9df.edid
> >
> > where
> >   /lib/firmware/edid/lg42lb9df.edid
> > is the 512-bytes EDID blob created according to data from above manual.
> > (note, that will only work for intel, radeon and nouveau drivers but will
> >   not work for closed drivers of AMD/nVidia)
> >
> 
> This certainly looks doable. That firmware file, should it contain all 4 
> tables or just the one for the port I'm connected to? Will it matter what 
> order they were in?

It should contain just the table for the port you're connected to.
For the HDMI ports the tables are 1024 bytes (e.g. two 512 bytes blocks,
not just one as I incorrectly wrote above). For the VGA port it's just one
512 bytes block.

Oh, and check the exact documentation of edid_firmware parameter as you can
adjust its value to tell kernel to which connector exactly it applies
(otherwise it will overwrite the EDID on other ports with working displays!).

Bruno

> Thanks
> Mark
> 
