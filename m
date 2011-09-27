Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab1I0Uwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:52:44 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:53608 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622Ab1I0Uwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:52:41 -0400
Date: Tue, 27 Sep 2011 23:52:33 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tero Kristo <t-kristo@ti.com>
Cc: "Balbi, Felipe" <balbi@ti.com>,
        "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        Paul Walmsley <paul@pwsan.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        "Basak, Partha" <p-basak2@ti.com>, parthab@india.ti.com,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Gadiyar, Anand" <gadiyar@ti.com>,
        sameo@linux.intel.com, tony@atomide.com,
        "Hilman, Kevin" <khilman@ti.com>, johnstul@us.ibm.com,
        "Sripathy, Vishwanath" <vishwanath.bs@ti.com>
Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
Message-ID: <20110927205230.GE2254@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1316691479-1849-3-git-send-email-keshava_mgowda@ti.com>
 <alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com>
 <CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com>
 <alpine.DEB.2.00.1109240020510.22872@utopia.booyaka.com>
 <CAP05o4Lwk2uUz5ou84GQsrsBdjW-FEYP-55pBzH+a74hP4g1Dw@mail.gmail.com>
 <cbad72cea703d117067f7c628f7db806@mail.gmail.com>
 <1317127327.3820.31.camel@sokoban>
 <CAP05o4J75jGLTH8prOGD79Mte4DOg9ukgwe3V-KHFnB1Q-fi4w@mail.gmail.com>
 <20110927132453.GF19603@legolas.emea.dhcp.ti.com>
 <1317134331.3820.44.camel@sokoban>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uwl7UQhJk99r8jnw"
Content-Disposition: inline
In-Reply-To: <1317134331.3820.44.camel@sokoban>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Uwl7UQhJk99r8jnw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Tue, Sep 27, 2011 at 05:38:51PM +0300, Tero Kristo wrote:
> > On Tue, Sep 27, 2011 at 06:48:35PM +0530, Munegowda, Keshava wrote:
> > > > So, you would need a mechanism to do something like this:
> > > >
> > > > pad a or b wakeup detected -> irq0
> > > > pad c or d wakeup detected -> irq1?
> > >=20
> > > yes, if get something like this , its perfect.
> >=20
> > can't you have different IRQs for each pad ? I mean, allocate one
> > irq_desc for each pad and let drivers request a pad/pin as an IRQ
> > source. Then, when you detect a pad wakeup, you can:
>=20
> Direct pad to irq mapping was turned down on some previous version of
> the prcm chain handler set, but yes, it is a potential approach. However

do you remember what was the reason for that being turned down ? Maybe I
can search the archives...

> the irq_desc allocation mechanism should be dynamic... there are some
> 200 programmable pads anyway.

I wouldn't worry too much about that. If you try to allocate irq_desc
dynamically, you would have to keep track of an "irq_base" for each
irq_desc you allocate, otherwise it's difficult to map it back to mux
number.

--=20
balbi

--Uwl7UQhJk99r8jnw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOgjeOAAoJEAv8Txj19kN1HiMIAIos/CO4zZZ1DkrUTLQNKSxQ
ys9ee5cV6bqd7FvW9K/RTWU5qLefFsEJePY5hNYPm/ud3qkaQOIU0pYs8Y0NY+Ix
EgR25pIn2biOwGgryQGQu5WuUsYLg0KWNTUqs3RakMma7rUOGCICadZGMJ39N6PZ
YS/OYNJWhCt9vSNJNHTt2FSLwJdbIV/z46ar3QMWukkojwMMWBOQ1wLgS59ZO7Wu
uvVOjm1x257jd7diwnuvADWJgZkrTUCj5VPObZtIGiPHu8CBh7usV5RVfMmGrnC+
OCUC/iXDNIy7VikBBRvz+N3b6gZ7u6wLUz9o1LIJkHL/980VkTtdNLdrlsorBfA=
=e3kx
-----END PGP SIGNATURE-----

--Uwl7UQhJk99r8jnw--
