Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2ISMEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 08:04:24 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:46546 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755682Ab2ISMEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 08:04:21 -0400
Date: Wed, 19 Sep 2012 14:59:35 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: balbi@ti.com, Sourav Poddar <sourav.poddar@ti.com>,
        gregkh@linuxfoundation.org, alan@linux.intel.com, tony@atomide.com,
        khilman@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com, paul@pwsan.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
 suspended.
Message-ID: <20120919115933.GJ3772@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com>
 <20120918140213.GA27463@arwen.pp.htv.fi>
 <CANOLnONC1oDN3yu=ipao2A6MfuSkZfROVPewWLLEM5fNTKipxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YQEH9CATo+4lan7A"
Content-Disposition: inline
In-Reply-To: <CANOLnONC1oDN3yu=ipao2A6MfuSkZfROVPewWLLEM5fNTKipxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YQEH9CATo+4lan7A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 19, 2012 at 02:52:18PM +0300, Grazvydas Ignotas wrote:
> On Tue, Sep 18, 2012 at 5:02 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Tue, Sep 18, 2012 at 06:10:50PM +0530, Sourav Poddar wrote:
> >> Greg's tty-next is not booting on 2420 based N800. The failure is
> >> observed at serial init itself. The reason might be that n800 tries to
> >> resume even though it is not suspended before.
> >>
> >> Reported-by: Paul Walmsley <paul@pwsan.com>
> >> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> >
> > FWIW:
> >
> > Reviewed-by: Felipe Balbi <balbi@ti.com>
> >
> > Paul does this fix the issue for you ? Note that it depends on a
> > previous patch Sourav sent [1]
> >
> > [1] http://marc.info/?l=3Dlinux-omap&m=3D134796819607889&w=3D2
> >
> > There's one thing that gets my attention, though, why only n800 would
> > fail here ?
> >
> > I wonder if we should be using:
> >
> > pm_runtime_set_active(dev);
> > pm_runtime_get_enable(dev);
> >
> > to prevent our runtime_resume() to be called from probe, but Sourav
> > tested and it doesn't work on BeagleBoard, but it works on PandaBoard.
> >
> > Does it ring any bell ??
>=20
> Well I guess it's normal resume callback is called during probe as
> pm_runtime_get_sync() is called there, and according to documentation
> [1], devices are assumed to be suspended before probe is called.
>=20
> According to [1], pm_runtime_set_active() should be called before
> pm_runtime_enable() to indicate to the core that device is active
> during probe if that's the case, I guess this means
> pm_runtime_get_sync() is not needed in that case, but I'm not sure
> what's the actual serial state during probe nowadays.
>=20
> [1] chapter 5 of Documentation/power/runtime_pm.txt:
> The initial runtime PM status of all devices is 'suspended', but it
> need not reflect the actual physical state of the device. Thus, if the
> device is initially active (i.e. it is able to process I/O), its
> runtime PM status must be changed to 'active', with the help of
> pm_runtime_set_active(), before pm_runtime_enable() is called for the
> device.

this is what I mean, actually. If we remove pm_runtime_get_sync() in
exchange for pm_runtime_set_active() before pm_runtime_enable(), it
works on PandaBoard, but breaks BeagleBoard.

--=20
balbi

--YQEH9CATo+4lan7A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQWbOlAAoJEIaOsuA1yqREtwIP/RpKtgRZ9Sory+BdUUkdW9MS
fBR4WfhE0zg0HIjWA4SOy8gg0IbjU74cJBWdoqLXTKiDr77PTiqp9AKiEjGu7TiU
n7V1ss+G5HsDzKKgzCwu5cjlswdhVu+xQw8Jk7cJQCS1nLA/bb548qrbV4dl4k3M
b5HvjUsvIEFk9+Trf/Sou1oKQ8rPWyTGzTj0TRCHMdkNAPEq4RD61elB1FEt5GC2
V+JIXlVTULiGfecVTPGfIY6EHumQYLS2YhYAtUwqWymKxAXGmR75olNgY3OLjv8Z
/a+8BgW/o7y1PWWcH4LMeeI7Mb5YWntepKK/i/4cQOSC9XyLNBizBT++YfrcqsLb
PAmhcjNBS/ydUf4BAQ4/1nAigG5oX+EVI881QrHMRj5ehBq2l7YpCccY4hc1tpV3
3hDz6lgjH+l7B98CjskWjI1gt6wrXBrictxlYtd+tPeTYcNL9JhVVC4t57IjX4eR
nJHgz7blAn55WQE8ijgkhvcE4siy099qRX0bHI4cPy0ehng+cQVnagTTcKGWYR5W
5N+GrTd5pBu7VxGsB8ApQnDdeImtr2OJwARYa/GsKVInUHCUIOu4Gb9ClU6+1VMv
b0DdCjfFmhhB2ePzPD6wzAedyI8lz7wpO2qmq+ivihyAc+MM9zapQ//TfOXUO+sW
aJRzsVfC386bPVNsQYwl
=+HId
-----END PGP SIGNATURE-----

--YQEH9CATo+4lan7A--
