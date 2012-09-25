Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2IYKmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:42:01 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:49619 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754766Ab2IYKl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:41:59 -0400
Date: Tue, 25 Sep 2012 13:37:03 +0300
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
Message-ID: <20120925103652.GN9137@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com>
 <CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com>
 <20120925083029.GG31374@n2100.arm.linux.org.uk>
 <20120925083118.GI9137@arwen.pp.htv.fi>
 <20120925091228.GI31374@n2100.arm.linux.org.uk>
 <20120925091112.GK9137@arwen.pp.htv.fi>
 <20120925092118.GJ31374@n2100.arm.linux.org.uk>
 <20120925094815.GL9137@arwen.pp.htv.fi>
 <20120925102958.GL31374@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vEfizQhTV1P/vojJ"
Content-Disposition: inline
In-Reply-To: <20120925102958.GL31374@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vEfizQhTV1P/vojJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 25, 2012 at 11:29:58AM +0100, Russell King - ARM Linux wrote:
> On Tue, Sep 25, 2012 at 12:48:16PM +0300, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Sep 25, 2012 at 10:21:18AM +0100, Russell King - ARM Linux wrot=
e:
> > > On Tue, Sep 25, 2012 at 12:11:14PM +0300, Felipe Balbi wrote:
> > > > On Tue, Sep 25, 2012 at 10:12:28AM +0100, Russell King - ARM Linux =
wrote:
> > > > > On Tue, Sep 25, 2012 at 11:31:20AM +0300, Felipe Balbi wrote:
> > > > > > On Tue, Sep 25, 2012 at 09:30:29AM +0100, Russell King - ARM Li=
nux wrote:
> > > > > > > How is this happening?  I think that needs proper investigati=
on - or if
> > > > > > > it's had more investigation, then the results needs to be inc=
luded in
> > > > > > > the commit description so that everyone can understand the is=
sue here.
> > > > > > >=20
> > > > > > > We should not be resuming a device which hasn't been suspende=
d.  Maybe
> > > > > > > the runtime PM enable sequence is wrong, and that's what shou=
ld be fixed
> > > > > > > instead? =20
> > > > > > >=20
> > > > > > > This sequence in the probe() function:
> > > > > > >=20
> > > > > > >         pm_runtime_irq_safe(&pdev->dev);
> > > > > > >         pm_runtime_enable(&pdev->dev);
> > > > > > >         pm_runtime_get_sync(&pdev->dev);
> > > > > > >=20
> > > > > > > would enable runtime PM while the s/w state indicates that it=
's disabled,
> > > > > > > and then that pm_runtime_get_sync() will want to resume the d=
evice.  See
> > > > > > > the section "5. Runtime PM Initialization, Device Probing and=
 Removal"
> > > > > > > in Documentation/power/runtime_pm.txt, specifically the secon=
d paragraph
> > > > > > > of that section.
> > > > > >=20
> > > > > > that was tested. It worked in pandaboard but didn't work on bea=
gleboard
> > > > > > XM. Sourav tried to start a discussion about that, but it simpl=
y died...
> > > > > >=20
> > > > > > In any case, pm_runtime_get_sync() in probe will always call
> > > > > > runtime_resume callback, right ?
> > > > >=20
> > > > > Well, if the runtime PM state says it's suspended, and then you e=
nable
> > > > > runtime PM, the first call to pm_runtime_get_sync() will trigger =
a resume
> > > > > attempt.  The patch description is complaining about resume event=
s without
> > > > > there being a preceding suspend event.
> > > > >=20
> > > > > This could well be why.
> > > >=20
> > > > that's most likely, of course. But should we cause a regression to
> > > > beagleboard XM because of that ?
> > >=20
> > > What would cause a regression on beagleboard XM?  I have not suggested
> > > any change other than more investigation of the issue and a fuller pa=
tch
> > > description - yet you're screaming (idiotically IMHO) that mere
> > > investigation would break beagleboard.
> > >=20
> > > Well, if it's _that_ fragile, that mere investigation of this issue by
> > > someone elsewhere on the planet would break your beagleboard, maybe it
> > > deserves to be broken!
> >=20
> > why are you always so over the top like that ? This is just
> > counter-productive to say the least.
>=20
> Because you are accusing me of potentially breaking your beagleboard
> for merely suggesting further investigation and a better commit message.

Where did I accuse you of anyting ? I just mentioned we experienced a
regression with beagleboard XM when using pm_runtime_set_active().

here's my quote:

> that was tested. It worked in pandaboard but didn't work on
> beagleboard XM. Sourav tried to start a discussion about that, but it
> simply died...

To add extra info, here you go:

We pinged Paul and asked if he had seen that before, he had no
pointers... Because Documentation/power/runtime_pm.txt was using a
mystruct->is_suspended flag, we just decided to follow the same
"design" since no-one was able to suggest why pm_runtime_set_active()
was breaking beagleXM nor how it was supposed to actually work.

Reading the code: pm_runtime_set_active() would tell pm_runtime core
the device is actually active by setting runtime_status to RPM_ACTIVE,
thus the following pm_runtime_get_sync() wouldn't actually call
runtime_resume() callback, but it would increment usage_counter.

I can't see why this would fail on beagleXM, but it does and we'd like
to hear in which situations this could fail...

--=20
balbi

--vEfizQhTV1P/vojJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQYYlMAAoJEIaOsuA1yqRE99sP/iT/aO9yXWR7FOZ326caWuGQ
G3ZPghtytkKYapkABwyjcJTmAwm3wtMlJntmB68lWyftLCuyFEsXsRwVdk3fSu98
IVaFnSLQhfWubTBZXC0cQR9fywLhPB2JMF2LSPNuX13jBHQlI4W+xxJ9TIsEDgRU
QXVZnXqwKxrbpxwKAWhlIkfreXitRtCPedraW5rThTfg4EaFsXy9GtxNL3jUPoB+
yKGrv+uFgaB8Fjll5kI1t36kOstpTGW2NSP7z0nl2/XzXR8FVDKwhVBSnkr67Qlp
0oS3auuajGyJYZLrYg9WNDU6HD4lLbKvqARuhDYHJC99YLEQYADTY4VkQy4FFn9c
d7Q9kSqFLAXF5w4offPcPX+PRYJg+UlqEfnJgX1uXfpuDnJUbGzgeFomlgY95FjW
kF7ybw3e9CXhxRIqMGUsUFIt89wYi8SG6UJx0q1OSSKtmTplQec+68dEP/zw90iT
FBDXjSFFr+N26561eMU7ZTOwnjJSPn/uKfwtVDCJLKOSS8tW+hWiQvun+Qj9YZeW
AAt/x/yymfQt34qZI3299DWNUj9ZVt4SkHxPIKkBOu+YootqEbsbpOAM5TctaPa2
5PDo+ZIfe7sRHrgKaUoFGnkllP8WDZGvvrYRGlcvjYlO7Lx+5NnBVdGFiQulScFX
ned+e/hinl9nbNyCXkhH
=foNJ
-----END PGP SIGNATURE-----

--vEfizQhTV1P/vojJ--
