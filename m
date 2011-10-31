Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208Ab1JaUYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 16:24:46 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:33264 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755400Ab1JaUYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 16:24:44 -0400
Date: Mon, 31 Oct 2011 13:24:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        linaro-dev@lists.linaro.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Archit Taneja <archit@ti.com>, Rob Clark <rob@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
Message-ID: <20111031132437.23eae6b8@jbarnes-desktop>
In-Reply-To: <20110917212529.6b452bf2@lxorguk.ukuu.org.uk>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<4E72320B.6020000@gmx.de>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
	<4E724659.5080709@gmx.de>
	<20110915195804.4e6d965b@lxorguk.ukuu.org.uk>
	<CAMP44s1ywhCV+FaudnwjwJUvj5Cf3_oz1M++kjXxRDGQpJ6-0w@mail.gmail.com>
	<CAF6AEGu2-O+2KuCrQPJ6-xejg8TCScrFVZSimgkAV_5Xs-bgkg@mail.gmail.com>
	<4E74C6C3.2000704@gmx.de>
	<CAPM=9twmPVrBPmUuEuTYHSzjDGHtfsmiVX6cozpAFYEaV-NcCg@mail.gmail.com>
	<4E74E3D6.8080401@gmx.de>
	<CAPM=9txHu7mzH8p8g=FmHsjvmAT-aMy-xEFj4odXEvnbs-bhMw@mail.gmail.com>
	<20110917212529.6b452bf2@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5KDHxCc=pf2uSdbbooXRJUj"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5KDHxCc=pf2uSdbbooXRJUj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 17 Sep 2011 21:25:29 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Just tell the X driver to not use acceleration, and it you won't get
> > any acceleration used, then you get complete stability. If a driver
> > writer wants to turn off all accel in the kernel driver, it can, its
>=20
> In fact one thing we actually need really is a "dumb" KMS X server to
> replace the fbdev X server that unaccel stuff depends upon and which
> can't do proper mode handling, multi-head or resizing as a result. A dumb
> fb generic request for a back to front copy might also be useful for
> shadowfb, or at least indicators so you know what the cache behaviour is
> so the X server can pick the right policy.
>=20
> > We've fixed this in KMS, we don't pass direct mappings to userspace
> > that we can't tear down and refault. We only provide objects via
> > handles. The only place its a problem is where we expose fbdev legacy
> > emulation, since we have to fix the pages.
>=20
> Which is doable. Horrible but doable. The usb framebuffer code has to
> play games like this with the virtual framebuffer in order to track
> changes by faulting.
>=20
> There are still some architectural screwups however. DRM continues the
> fbdev worldview that outputs, memory and accelerators are tied together
> in lumps we call video cards. That isn't really true for all cases and
> with capture/overlay it gets even less true.

Sorry for re-opening this ancient thread; I'm catching up from the past
2 months of travel & misc.

I definitely agree about the PC card centric architecture of DRM KMS
(and before it, X).  But we have a path out of it now, and lots of
interest from vendors and developers, so I don't think it's an
insurmountable problem by any means.

I definitely understand Florian's worries about DRM vs fb.  If nothing
else, there's certainly a perception that fb is simpler and easier to
get right.  But really, as others have pointed out, it's solving a
different set of problems than the DRM layer.  The latter is actually
trying to expose the features of contemporary hardware in a way that's
as portable as possible.  That portability comes at a cost though: the
APIs we add need to get lots of review, and there's no doubt we'll need
to add more as newer, weirder hardware comes along.

Really, I see no reason why fb and DRM can't continue to live side by
side.  If a vendor really only needs the features provided by the fb
layer, they're free to stick with a simple fb driver.  However, I
expect most vendors making phones, tablets, notebooks, etc will need
and want an architecture that looks a lot like the DRM layer, with
authentication for rendering clients, an command submission ioctl for
acceleration, and memory management, so I expect most of the driver
growth to be in DRM in the near future.

And I totally agree with Dave about having a kmscon.  I really wish
someone would implement it so I could have my VTs spinning on a cube.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/5KDHxCc=pf2uSdbbooXRJUj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOrwQFAAoJEIEoDkX4Qk9h9gUP/1z1Cg073nOfPG8acxdk00jX
wn30vGUwDutNIdi0et+flDOJQtaoiCtgTPDmZLykXmxLBuyl5VdHk5dg2LdEiQWB
lpPQ5S1VM/Zd1N0AYI5H2TP+UwiXElW7e75F8y+18EZdVGuFAL5b98T+oUtoT4Xw
iENJc5fKpyxWEnCdWIIr1SIB2hSSAdyiOvCC62jxMtC2PQg7FzYYi9DMoZO2//Qg
pDnR/aJMnAR+nldK/t084gpWJHMKvVgIQjepu2b8qC+YEoTxEDuTHpBsAGwLEi3R
p/vWstJ3H+ISvnHHEzme5b59e+RA+iCwgJJadoe8GtZ+6hYDx4wx5bxoUz381Ssf
3+2PPjuXxOVMXgHHJysAccVhmgNzQMvidUTHI42s3DrI/lfxQblQAiMKPaLTvuc/
eq0j9SRl4qz1tz3EvEUKXOxlsAGTxKlGyOHeFbrJTPFswvC1JCYcGjFUV10HFI3X
4KBLFgNNGeOefC9tqkUXhrKW/XdN3uZEGbq9htlSlHjPoAsgbvEXvzY1VUZq1eLL
EPFmlJ1XdMfUp9oUDK1YxkONz4Ve0io6eiskw8U9vK7WCZo9vWODfeQoObPIEyS1
1gPiYuzRTxSPEj8jl4lTwBppdd1SHXdJ4OIiG8Tysjcs+ntB7Les3JtfAqZn6Re6
F41UUvgeOZfHx2+vA7BU
=nSsT
-----END PGP SIGNATURE-----

--Sig_/5KDHxCc=pf2uSdbbooXRJUj--
