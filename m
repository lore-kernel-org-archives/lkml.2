Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab2IYJxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:53:15 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:52692 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754009Ab2IYJxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:53:12 -0400
Date: Tue, 25 Sep 2012 12:48:16 +0300
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, "Poddar, Sourav" <sourav.poddar@ti.com>,
        gregkh@linuxfoundation.org, khilman@ti.com, paul@pwsan.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, linux-serial@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alan@linux.intel.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
 suspended.
Message-ID: <20120925094815.GL9137@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com>
 <CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com>
 <20120925083029.GG31374@n2100.arm.linux.org.uk>
 <20120925083118.GI9137@arwen.pp.htv.fi>
 <20120925091228.GI31374@n2100.arm.linux.org.uk>
 <20120925091112.GK9137@arwen.pp.htv.fi>
 <20120925092118.GJ31374@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AGBBLMjITsWHeOTZ"
Content-Disposition: inline
In-Reply-To: <20120925092118.GJ31374@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AGBBLMjITsWHeOTZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 25, 2012 at 10:21:18AM +0100, Russell King - ARM Linux wrote:
> On Tue, Sep 25, 2012 at 12:11:14PM +0300, Felipe Balbi wrote:
> > On Tue, Sep 25, 2012 at 10:12:28AM +0100, Russell King - ARM Linux wrot=
e:
> > > On Tue, Sep 25, 2012 at 11:31:20AM +0300, Felipe Balbi wrote:
> > > > On Tue, Sep 25, 2012 at 09:30:29AM +0100, Russell King - ARM Linux =
wrote:
> > > > > How is this happening?  I think that needs proper investigation -=
 or if
> > > > > it's had more investigation, then the results needs to be include=
d in
> > > > > the commit description so that everyone can understand the issue =
here.
> > > > >=20
> > > > > We should not be resuming a device which hasn't been suspended.  =
Maybe
> > > > > the runtime PM enable sequence is wrong, and that's what should b=
e fixed
> > > > > instead? =20
> > > > >=20
> > > > > This sequence in the probe() function:
> > > > >=20
> > > > >         pm_runtime_irq_safe(&pdev->dev);
> > > > >         pm_runtime_enable(&pdev->dev);
> > > > >         pm_runtime_get_sync(&pdev->dev);
> > > > >=20
> > > > > would enable runtime PM while the s/w state indicates that it's d=
isabled,
> > > > > and then that pm_runtime_get_sync() will want to resume the devic=
e.  See
> > > > > the section "5. Runtime PM Initialization, Device Probing and Rem=
oval"
> > > > > in Documentation/power/runtime_pm.txt, specifically the second pa=
ragraph
> > > > > of that section.
> > > >=20
> > > > that was tested. It worked in pandaboard but didn't work on beagleb=
oard
> > > > XM. Sourav tried to start a discussion about that, but it simply di=
ed...
> > > >=20
> > > > In any case, pm_runtime_get_sync() in probe will always call
> > > > runtime_resume callback, right ?
> > >=20
> > > Well, if the runtime PM state says it's suspended, and then you enable
> > > runtime PM, the first call to pm_runtime_get_sync() will trigger a re=
sume
> > > attempt.  The patch description is complaining about resume events wi=
thout
> > > there being a preceding suspend event.
> > >=20
> > > This could well be why.
> >=20
> > that's most likely, of course. But should we cause a regression to
> > beagleboard XM because of that ?
>=20
> What would cause a regression on beagleboard XM?  I have not suggested
> any change other than more investigation of the issue and a fuller patch
> description - yet you're screaming (idiotically IMHO) that mere
> investigation would break beagleboard.
>=20
> Well, if it's _that_ fragile, that mere investigation of this issue by
> someone elsewhere on the planet would break your beagleboard, maybe it
> deserves to be broken!

why are you always so over the top like that ? This is just
counter-productive to say the least.

What I'm trying to say here, is that there might be a bug either on pm
core or on OMAP3's implementation and I'd like to get input from Tony,
Santosh, Paul, etc before going forward. Maybe it's something they've
already been through, or maybe it rings a bell and points to somewhere
we should look for.

anyway, instead of feeding your ego, we can stop this discussion and let
Sourav see what he can come up with.

--=20
balbi

--AGBBLMjITsWHeOTZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQYX3fAAoJEIaOsuA1yqREVgwQAK71TpUFAgDu4L/tvpLdFoLD
nSVtlCdLFYE91nr8op84NG2zbcpk/F67tCmAgdjL1bO4aZKYBnb0GC6oaoz0Gh94
yswOSye4sH8zFDVEfvvJhgAbi+MxnBnjyqIbtCWQYvxSpA9KnQIE/NVlPn4sTELt
4LZ5mmM7UruG1ciILCIeNuD3ADAzGwGadL61ym73Bvp9D43gAMdGsNX7AH3a89ee
nJLYLdks8IHGwj4UlmuTirTWeKwa0Hc3NcyYrVufVH4jW1rzCgepZrIh6TZOi7G7
brH4egrx9ATnI1E7HcHDOlgdMBu4+Cyo8tZJF8V5KQPUrcETQ092rUoggYuXeLvR
9EuKlrPXjGB0/APCWiXM16NMq4poUN7AEg5v/iYpl67unrKWdB/EmuGHMUEze4vt
ixNipbrhDSxW7NiP+C54llHG7260bQuPLO7JqbgnMe92VMFnR+mlHj4pE5LDlnJi
pVl0RhgD0aA50h/SOAB5X8t+P2p3z0d9YU19WkSY5ukeK4ZEkJSZ9nZvpLQ2IWpm
IhMRuqGqxDtJ5qeC6lELz4HVFdH6bti9UENP1lNek99KDB8P9w4rFA2UVlCbW8YO
hpRbelP898V1XDoma4ymwFzHEvEIPHOUZUh9/TZmE+2ZL2LgmmR0Z4vfWkO899Oa
AdgQJqBi0eXpV56cjvvC
=H4tu
-----END PGP SIGNATURE-----

--AGBBLMjITsWHeOTZ--
