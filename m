Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab2LAO6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:58:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64987 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2LAO6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:58:20 -0500
Date: Sat, 1 Dec 2012 15:58:14 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
Message-ID: <20121201145814.GB18209@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
 <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de>
 <50B73710.2040102@nvidia.com>
 <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
 <50B874C7.5030208@nvidia.com>
 <20121130103850.GA28367@avionic-0098.adnet.avionic-design.de>
 <50B9EA76.10803@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <50B9EA76.10803@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:jFrIePNLFzlp6plq0DGcltGuKnmGlfX+MmOqV1QZJJK
 3hX8XiinbHO2rxi337P36+huOcgiDQCNzlrwE3HUOGrJuwjRPq
 weLCkcEGg7CLRhWUKTRyUHaWQuKtnvCtzXkgErsJMfXI1DwSts
 31pjJ857pWB6O+0/w5vJ79kpepm2ALR77xUFU1O4jp4H8VjjTU
 AfFm+cR+ApAfQF49vn7ToRQ4Ci3v4IO2A6mZqvN1Xfls3jqrXm
 p9D0vEclKxEFoJfq72Mkn8YqIh1+Evbp3ccDJjP8ZBU6TlEqoh
 pDXUxNaYntXUCo3bY4kqcQRout4z5yxJ9gcmC3Igv5VAyqjbY0
 ZLRA9Nolnswt0kEndVPL6+zPA5OZX14KVHVsvtofsddfaJXR8v
 Vddv0glMXa7EVZVCyO5V4Q5kYYWrBvuCuo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 01, 2012 at 01:31:02PM +0200, Terje Bergstr=C3=B6m wrote:
> On 30.11.2012 12:38, Thierry Reding wrote:
> > * PGP Signed by an unknown key
> > The above implies that when you submit code it shouldn't contain pieces
> > that prepare for possible future extensions which may or may not be
> > submitted (the exception being if such changes are part of a series
> > where subsequent patches actually use them). The outcome is that the
> > amount of cruft in the mainline kernel is kept to a minimum. And that's
> > a very good thing.
>=20
> We're now talking about actually a separation of logical and physical
> driver. I can't see why that's a bad thing. Especially considering that
> it's standard practice in well written drivers. Let's try to find a
> technical clean solution instead of debating politics. The latter should
> never be part of Linux kernel reviews.

I don't know where you see politics in what I said. All I'm saying is
that we shouldn't be making things needlessly complex. In my experience
the technically cleanest solution is usually the one with the least
complexity.

> > Okay, so what you're sayingCan here is that a huge number of people hav=
en't
> > been wise in using the preprocessor for register definitions all these
> > years. That's a pretty bold statement. Now I obviously haven't looked at
> > every single line in the kernel, but I have never come across this usage
> > for static inline functions used for this. So, to be honest, I don't
> > think this is really up for discussion. Of course if you come up with an
> > example where this is done in a similar way I could be persuaded
> > otherwise.
>=20
> We must've talked about a bit different things. For pure register defs,
> I can accommodate changing to #defines. We'd lose the code coverage
> analysis, though, but if the parentheses are a make-or-break question to
> upstreaming, I can change.
>=20
> I was thinking of definitions like this:
>=20
> static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_addr_f(u32 v)
> {
> 	return (v & 0x1ff) << 0;
> }
>=20
> versus
>=20
> #define host1x_sync_cfpeek_ctrl_cfpeek_addr_f(v) ((v) >> 16) & 0x3ff
>=20
> Both of these produce the same machine code and have same usage, but the
> latter has type checking and code coverage analysis and the former is
> (in my eyes) clearer. In both of these cases the usage is like this:
>=20
> writel(host1x_sync_cfpeek_ctrl_cfpeek_ena_f(1)
> 		| host1x_sync_cfpeek_ctrl_cfpeek_channr_f(chid)
> 		| host1x_sync_cfpeek_ctrl_cfpeek_addr_f(rd_ptr),
> 	m->sync_aperture + host1x_sync_cfpeek_ctrl_r());

Again there's no precedent for doing this with static inline functions.
You can do the same with macros. Type checking isn't an issue in these
cases since we're talking about bitfields for which no proper type
exists.

Two other things about the examples above: the definitions should be all
caps and it would be nice if they could be made a bit shorter.

> > But I don't see how that's relevant here. Let me quote what you said
> > originally:
> >=20
> >> This is actually the only interface to read the max value to user spac=
e,
> >> which can be useful for doing some comparisons that take wrapping into
> >> account. But we could just add IOCTLs and remove the sysfs entries.
> >=20
> > To me that sounded like it was only used for debugging purposes. If you
> > actually need to access this from a userspace driver then, as opposed to
> > what I said earlier, this should be handled by some IOCTL.
>=20
> There's a use for production code to know both the max and min, but I
> think we can just scope that use out from this patch sest.
>=20
> User space can use these two for checking if one of their fences has
> already passed by comparing if the current value is between min and
> fence, taking wrapping into account. In these cases user space can f.ex.
> leave a host1x wait out from a command stream.

But you already have extra code in the kernel to patch out expired sync-
points. Is it really worth the added effort to burden userspace with
this? If so I still think some kind of generic IOCTL to retrieve
information about a syncpoint would be better than a sysfs interface.

Thierry

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQuhsGAAoJEN0jrNd/PrOh7JkP/0OZP0t+TvsT38FBxELUVKDM
jcvApx8OaDa6I78YKsOWFtZLEw5u0w+J6t2DglRu/4n47Gtue0NMfWsnTRep5A4V
9nzdlFuuHYfBlKIL8avUux8jSYHO7F77ap4lS4iiMpa5PzYqcN3dQcXk/Oxf/H8j
LXU0W0UuyOw51z0uMz8G1H8TJ6SSq2ixcFHAKPX+n0R8HYcQqmp8HSe7vVqyzrcI
VA3NxXGA8YGbfNfKzkj8dAs8jhpGtDJPmXVeJnWhCBJc9iNephnPxhKkzPj3Q+uH
o7zS1W1TX557GSwc2hOLFM4034QZ0uxMh4IAp72+aBJkv2dJVePeID3MOSMS509K
nOVYrPZszM2imGLuw1COdoi15sPUpDHO4Sa7jBqhQMBX0P6fAbK8fgQTRR3N8zxU
X6uh8M3XiSRqApUbeqQkU5CZKvwO71XYly4ZsKh1oGO8bYfRAzLHWsfFYO7k1Vl2
I6lF1tUf+NL8IuklF3Wq8d4JPSJnTbFLr8YuRWRffTxrqwioQJqRelXt7eNfz0Ee
LFMyrUYlhc+CVVp1vDGW8TsoirR8xdFvJnm4mGJw5HJhnOYK7q6df8eS2+/pP0aL
JQOPSpBsUBxggz6MFOUCm1VPm+G/l2fyNl5/76RvKxUiocMWHxcM3U2M5fb9KhTp
iLkmcjp7Wb43YDl3VNYp
=W1HG
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
