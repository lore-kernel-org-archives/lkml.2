Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab2F1KRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:17:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46513 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932466Ab2F1KRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:17:31 -0400
Date: Thu, 28 Jun 2012 11:17:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "cw00.choi@samsung.com" <cw00.choi@samsung.com>
Subject: Re: [PATCH] Extcon: Arizona: Add driver for Wolfson Arizona class
 devices
Message-ID: <20120628101728.GB28922@opensource.wolfsonmicro.com>
References: <30036799.190541340849289982.JavaMail.weblogic@epml02>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
In-Reply-To: <30036799.190541340849289982.JavaMail.weblogic@epml02>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 28, 2012 at 02:08:10AM +0000, MyungJoo Ham wrote:

> I only have some performance concerns that may be ignored
> if you don't care of it for this device.

To be honest I think if we ever care about performance with extcon we've
got a serious problem - cable insertion shouldn't be happening too
quickly and obviously the userspace API has all the same issues.

> > +#define ARIZONA_CABLE_MECHANICAL "Mechanical"
> > +#define ARIZONA_CABLE_HEADPHONE  "Headphone"
> > +#define ARIZONA_CABLE_HEADSET    "Headset"

> > +static const char *arizona_cable[] =3D {
> > +	ARIZONA_CABLE_MECHANICAL,
> > +	ARIZONA_CABLE_HEADSET,
> > +	ARIZONA_CABLE_HEADPHONE,
> > +	NULL,
> > +};

> For ARIZONA_CABLE_HEADPHONE and ARIZONA_CABLE_MECHANICAL, you can
> use extcon_cable_name[EXTCON_HEADPHONE_OUT] and
> extcon_cable_name[EXTCON_MECHANICAL].

> It appears that I need to rephrase line 38-41 of extcon_class.c. Anyway,
> it is not recommended to import the whole list. However, it is strongly
> recommended to reuse the corresponding entries from the list.

That's what I initially wanted to do but there's real usability problems
fishing the values out of the array, the obvious method does things like
this:

drivers/extcon/extcon-arizona.c:62: error: initializer element is not const=
ant
drivers/extcon/extcon-arizona.c:62: error: (near initialization for 'arizon=
a_cable[0]')

for example and you don't want the driver to end up looking like line
noise.  Perhaps there's some simple way of doing it that didn't occur to
me but there aren't any examples in tree.

> Anyway, the HEADSET appears to be a pair of HEADPHONE and MIC.
> You may replace HEADSET with MIC in arizona_cable and remove exclusive[]
> and regard HEADPHONE | MIC as "HEADSET".

This was done following the example of the Android switch API which
defines these as separate cable types.  Cable type is probably the wrong
name here but it's a bit late now...

> > +	/* If we got a high impedence we should have a headset, report it. */
> > +	if (info->detecting && (val & 0x400)) {
> > +		ret =3D extcon_set_cable_state(&info->edev,
> > +					     ARIZONA_CABLE_HEADSET, true);

> You may use extcon_set_cable_state_ for the performance
> as you already know the index of HEADSET. Or extcon_update_state();

I didn't use set_cable_state_ as the _ makes it look like
extcon_set_cable_state() is the intended call, obviously almost every
driver will have the indexes known.  If there's much preferenced here
I'd expect the main function to take the numbers as argument and then
have extcon_set_cable_state_by_name() or something.

extcon_update_state() is a bit annoying to use as you need defines for
both indexes and bits or you need shifting so the code looks ugly. =20

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP7C8vAAoJEBus8iNuMP3d59gP/RA3od8vkKQEUvde9h5AVEzj
DLbEA9jDKE48t7BmNQ2AFH5lkzKt37XdMyg73brAnbRPxN5nZdHNvxnbkfkgoB7y
C8LDWjwanUGdwXSOUBkKoUY+rJ0f+pel7gAmYf35JpQ0HEb0ub/q9zNv6jxA8Z1l
CgPnQxVpzKVp+HIPEYOEvPhnnezaP5oOyEpU8KLXOITpamzCnG1cat6rxzrjOqB1
eSx8bOL65qW/+ORtPf7fC95XszGSjdfXb4pKYl/+xfKnEZzpiU93y0b/kTOneM8P
ftEV5i1XE8e4sg+2xNQheuHOHQtBIE3rotVQ/B0M+Z9mM6+c/gfH3ROgs2wRVUum
MKwVU89Sy3281OTmRS2eS6EYWGGB+RLLMvMwEl6vfBDY3Jm2EsU+sPpx5+Vwq6BC
gr9Q7PDKqkT3s/K4ax77JWtNVg0vylyx8IOEakigurB7tPjOP4VYGMhDHuHgl6d3
odYaWONAPpn3ZYSjL+/YpDW2Wuoy/xdDAwdv3f8I0G/8m984fHx/zGskyN8l3pSU
0XQ5/BhTPBjz8FbVZrFSUDnvYZQveMiW34lqJ7v40WXIldl4//HplJ7WE2nDv9FM
jFuwf7P6Vt6n3V/iveZ5Rwy+WJMXG/0xFB7so/mvhhgo0gfPq5mi/6MUu4JvFi4a
f6Ib4a+wgd+8nEdT3JkC
=m4PJ
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
