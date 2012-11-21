Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab2KUBbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:31:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48311 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678Ab2KUBbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:31:50 -0500
Date: Wed, 21 Nov 2012 10:31:34 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>, Rob Herring <rob.herring@calxeda.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-pm@vger.kernel.org,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
Message-ID: <20121121013133.GE4673@opensource.wolfsonmicro.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
 <1353149747-31871-2-git-send-email-acourbot@nvidia.com>
 <20121120215429.B621F3E1821@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a1QUDc0q7S3U7/Jg"
Content-Disposition: inline
In-Reply-To: <20121120215429.B621F3E1821@localhost>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a1QUDc0q7S3U7/Jg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 20, 2012 at 09:54:29PM +0000, Grant Likely wrote:
> On Sat, 17 Nov 2012 19:55:45 +0900, Alexandre Courbot <acourbot@nvidia.com> wrote:

> > With the advent of the device tree and of ARM kernels that are not
> > board-tied, we cannot rely on these board-specific hooks anymore but

> This isn't strictly true. It is still perfectly fine to have board
> specific code when necessary. However, there is strong encouragement to
> enable that code in device drivers as much as possible and new board
> files need to have very strong justification.

This isn't the message that's gone over, and even for device drivers
everyone seems to be taking the whole device tree thing as a move to
pull all data out of the kernel.  In some cases there are some real
practical advantages to doing this but a lot of the people making these
changes seem to view having things in DT as a goal in itself.

> I'm thinking about the scripts as trivial-to-parse ascii strings that
> have a very simple set of commands. The commands use resources already
> defined in the node. ie. 'g0' refers to the first entry in the gpios
> property. 'r0' for the regulator, 'p0' for the pwms, 'd' means delay. By
> no means take this as the format to use, it is just an example off the
> top of my head, but it is already way easier to work with than putting
> each command into a node.

It does appear to have some legibility challenges, especially with using
the indexes into the arrays of resources.  On the other hand the arrays
should be fairly small.

> > +Platform Data Format
> > +--------------------
> > +All relevant data structures for declaring power sequences are located in
> > +include/linux/power_seq.h.

> Hmm... If sequences are switched to a string instead, then platform_data
> should also use it. The power sequence data structures can be created at
> runtime by parsing the string.

Seems like a step backwards to me - why not let people store the more
parsed version of the data?  It's going to be less convenient for users
on non-DT systems.

As I said in my earlier reviews I think this is a useful thing to have
as a utility library for drivers independantly of the DT bindings, it
would allow drivers to become more data driven.  Perhaps we can rework
the series so that the DT bindings are added as a final patch?  All the
rest of the code seems OK.

--a1QUDc0q7S3U7/Jg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQrC7uAAoJELSic+t+oim9NTgP/3oUSoRnG5DR736OIwo3IEcq
lR9QRSr43anEyTnX1ZzIAgJm9byAvH3TRcCG0RlCKb0JPlPvMcuiWnExeR5Xweoj
d30s7bJ+btF2lk1LJPx6uFS6rhkPswW2eNCNG88z/ogDJnRg+mUlBaJFoMZBJ5MI
DuP0WnVKrFXt7ixTm0/57z3tLBcXu9YyOttIoBR20Uk6sLOz4RWpbBjNEkit+2Kb
Exrfxlbj4zEK0dVCjE2NFG/X77kXBoBHI1qplFdz5L+yEPIwAhyE+hjDVzR/H3G3
x9MUP/LF8ttuKvl0kWfn3mN6/BObK/pGirFdk9+l/HhLS0jzVewZiZQr72K0pIql
RVTEkc8kw4hiVMMZkzXsUy1LLDSH2C6SlrMMT2yZO2VekKfy9Fw6Kfbxl3ik2Px1
Fg+lApYi1QrYfERBmUXPwr5ez1YZyL+TgLbZ87AC9gcDgCqHA/hGhv35A82m6ACQ
Xp8wVxnPcUcDjvHCcvHDiL4UVa+qW1pxx5cZr5FUQENnl2n5byWcxLdH1rvwC9J3
r2VRmVSyunIBaBi3bZc+BOE8UhiXAT0g59mIOkdVQGfSo5B1WeiAdSXawJWO835p
I+dkhBA+uWIx5tPMan396vMqGaxydwtpA9iOsCjz9l2q+2sYflvJKUrdAzdU9xDh
6PLj38T+S4Nw2nVEUU7N
=EhhC
-----END PGP SIGNATURE-----

--a1QUDc0q7S3U7/Jg--
