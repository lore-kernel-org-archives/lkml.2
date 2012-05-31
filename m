Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab2EaSzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:55:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49510 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754916Ab2EaSzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:55:21 -0400
Date: Thu, 31 May 2012 19:55:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <Krystian.Garbaciak@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH 3/4] regmap: Add support for register indirect addressing.
Message-ID: <20120531185517.GD24139@opensource.wolfsonmicro.com>
References: <201205311619.q4VGJ8S2014801@sw-eng-lt-dc-vm2>
 <20120531172541.GM2666@opensource.wolfsonmicro.com>
 <751C305CD2876B4990194D0512DE8BF2441CA8F3@SW-EX-MBX01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <751C305CD2876B4990194D0512DE8BF2441CA8F3@SW-EX-MBX01.diasemi.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 31, 2012 at 06:37:00PM +0000, Krystian Garbaciak wrote:

Fix your mailer to word wrap between paragraphs, your mails are not easy
to read.

> > Wouldn't something naturally sorted like a rbtree be a more direct way =
of doing
> > this?

> I expect here to have one or two ranges registered. Do you think,
> rbtree will be more efficient?

It might make the code rather more obvious, right now it's not exactly
clear.

> > > +		range_cfg =3D NULL;
> > > +		for (n =3D 0, min_base =3D UINT_MAX; n < config->n_ranges; n++)
> > > +			if (range_base <=3D config->ranges[n].base_reg &&
> > > +			    config->ranges[n].base_reg <=3D min_base)
> > > +				range_cfg =3D &config->ranges[n];
> > > +

> > I've stared at this for a little while and I'm really not sure what it'=
s supposed to
> > do.  The whole thing with min_base is just a bit odd, we're doing compa=
risons
> > against it but we never update it so why aren't we using a constant, an=
d in fact
> > the comparison is always going to be true since we're comparing against
> > UINT_MAX.

> > I suspect it's supposed to pick the range with the lowest base but I'm =
not
> > convinced it does that.

> I  am searching for a range configuration with the lowest address
> range, that was not added yet.  I use range_base as a pointer to mark
> the position of base address for the next range to be added.

None of which really addresses what I'm saying at all - the code is very
obscure, especially whatever you're doing with min_base which works out
as an always true comparison with a constant as far as I can tell.

> > > +		if (!range_cfg || range_cfg->base_reg > range_base) {
> > > +			/* Range of registers for direct access */

> > This is making my head hurt too, possibly because of the lack of clarit=
y in the
> > above.

> Any empty space before configured virtual range is filled with range
> used for direct access. Empty address space, after all defined ranges,
> is used for direct access too (If that makes sense?). To mark such
> range (translate_reg=3D=3DNULL).

I got what it's supposed to do, it's just not at all obvious how it
accomplishes this.  Like I say the fact that the immediately preceeding
code upon which it relies is as clear as mud isn't helping here.

> > > +			/* Update page register (may use caching) */
> > > +			ret =3D _regmap_update_bits(map, range-
> > >page_sel_reg,
> > > +						range->page_sel_mask,
> > > +						_page << range-
> > >page_sel_shift,
> > > +						&change);
> > > +			if (ret < 0)
> > > +				return ret;

> > Why the comment about the cache - why would this go wrong?

> Nothing. _regmap_update_bits() is used, so the cache can be hit here
> and speed up paging.

So why is this so surprising that we need a comment?  The comment seems
like it's flagging something that might be broken but fortunately isn't.

> Legal Disclaimer: This e-mail communication (and any attachment/s) is con=
fidential and contains proprietary information,=20
> some or all of which may be legally privileged. It is intended solely for=
 the use of the individual or entity to which it
> is addressed. Access to this email by anyone else is unauthorized. If you=
 are not the intended recipient, any disclosure,=20
> copying, distribution or any action taken or omitted to be taken in relia=
nce on it, is prohibited and may be unlawful.
>=20
> Please consider the environment before printing this e-mail

You might want to see about removing this...  clearly you can do so
since your patches don't have it?

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPx74TAAoJEBus8iNuMP3dTTsP/3dx0kdzXk534hffAaxa2jLE
I6VvCO4SnysnyCkLhGAXFLfo67IqsbsHt1kYAk0U1Y9KngXamLLfQiN9njFXSMoo
m0UmiaCvZQHiVwS4+hjSHNTUpeiOMpGUQ3ybSd7HnJrw+kI9zlFaty4gSGHo+lPl
7rHCqbpEWwflUTTLz+rnDYO9iIY1miJv3cjiYWgnIgdMZfw4/wKbxetBfQNnavE4
yVonr/IbkInuANIufghNwVkwLbVoKML7sGelg8Odm59bjOOrQ9k+RjcaJ0ZosRar
x1iA1lwcaOQbhGnj7h7X9DXH4899KgwsAJW1RvDu7745Azi/5KPWHT2rH5xGLWvl
2szjQzSKA+/iVDPFXpFPAdFFw66vGUwviil5xjucPQ0SuMNDZe5Rl7GEmnRtbgu9
4RBZbZO7HNYfeCYvohjG2bg1s97mFBjR/WFHIM+889y79MjcTkVFRssTWrhAZ/kQ
y+rFJxDKpG7tpXuN07ZtVkXbF/zm1KoPdpaggDMcGXa2GO2jPyHa2lEIpVIQ254o
sZhLjtwU13nRQlFWbEKcYdgMVdXezo3UP1BhF+f+X3U2zmmlctQQZfD+12WqM1vk
bZ7BiYTwAM1KHFApgwXMWMWpKKYnXZtHZo13XLBzBfvHKTJKSN0vVE9fUAtjMkhd
xMAGehSSJ/ACTE1S/RUf
=lfJV
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
