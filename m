Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab2DTLqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 07:46:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50495 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752991Ab2DTLqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 07:46:05 -0400
Date: Fri, 20 Apr 2012 12:46:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, lrg@ti.com
Subject: Re: [PATCH] regulator: Provide a check for dummy regulator
Message-ID: <20120420114602.GB3259@opensource.wolfsonmicro.com>
References: <1334829097-32084-1-git-send-email-jaswinder.singh@linaro.org>
 <20120419124204.GE3046@opensource.wolfsonmicro.com>
 <CAJe_ZhfbFq98fT56CS-q4VoU8wnybj-+swfB+Jrknd3Zmt9V8g@mail.gmail.com>
 <20120419162905.GA3084@opensource.wolfsonmicro.com>
 <CAJe_Zhd0H6kXBhqdynuZqhbcPq8ARWu5SMbs=hQT2n8stzRvXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <CAJe_Zhd0H6kXBhqdynuZqhbcPq8ARWu5SMbs=hQT2n8stzRvXQ@mail.gmail.com>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 20, 2012 at 01:02:06PM +0530, Jassi Brar wrote:

> Say, an audio CODEC chip has a simple PLL1 run by main voltage
> domain(Vmain). PLL1 can only support 11025x sample rates.
> Another PLL2 on the chip, powered by optional supply Vaux, could
> provide 8000x sample rates. Obviously low-end platforms could choose
> to not provide Vaux.

> The platform has some other drivers that need to have dummy regulator
> support enabled.

> How is the CODEC driver supposed to know if 'vaux' is actually present?
> Because if it isn't present, the driver wouldn't declare support for
> 8000x  rates.
> regulator_get() would always succeed, and regulator_is_enabled() would
> always return 1, even if the vaux is not supplied.

This is just one of those cases that won't ever work well with dummy
regulators - the whole reason you're supposed to actually specify the
supplies accurately and not use them is that we've got no way of telling
if the supply there or not from consumer drivers as we just
unconditionally claim that the supply is there.

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPkUvwAAoJEBus8iNuMP3dH28P+gLAxtUZTn80rXvDVEAl3Eat
Vfa+KICCcw6+E1/7CDzP1xKrXn9ZgFXthXb8RyyfZd3eJsPPVfMUzTPMschQFl7J
9al1a/ASKhE0bB7Tr8nnP6tePf3nuGWtzKAgbFsB52Ek6LtSq6z5T/PK41vSl8Nf
oyO9+v7lYOr5BSj5+Z5eqps5ZoL64mLcgtXdVOinfjS/Fi6s2ig9IyB4MeNQ5rtQ
qEgDo1mtQVJEDj75B4HdxsrkwTJRRNJFwPR1G0lTgmkD6JVX3umw4kM1pogcrU2W
zDA8ANCWjYhnZpSEchlw1Lv0sKbYimMrjMfD6hIMGuVSG97l0XHNb+tSmODsDkDq
QWYtKSjv0U7H21K25PkMQV/UjPrSEWyR6sk3ksf8jkhLwtp2UpjuBWndm3aH+NLV
BmLuRQ90vwzAlV+nvrASv4RbUIGrtYYLDmV7KZo1Confkq45EHzAVXfYuFm2JhS3
B+ZptL83nLQoP+ha9TdGXnEdJBBtLHUOPQWLfyCHoWWTd7pu0FOIvSn7v66HUcwJ
JEPoe9m6ebAHghB+n4MvrDFShr8h/wkJKHqPM3AMmTM/zIc6RLH377p1nyUx6uDW
70vt4JEQuXn27/JNenDkuA6s2iriM97BsDVxYDHrsW3io+Uzg2KU6usOmeHJvBsY
RwksT6VHRR1l7UhaMsrW
=Gfl+
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
