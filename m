Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489Ab2GCILw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:11:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56679 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab2GCILt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:11:49 -0400
Date: Tue, 3 Jul 2012 10:11:38 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: linux-next: build failure after merge of the final tree (pwm
 tree related)
Message-ID: <20120703081138.GA25183@avionic-0098.mockup.avionic-design.de>
References: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au>
 <20120703161846.59fee8d3815993bcea122eeb@canb.auug.org.au>
 <20120703062351.GA25217@avionic-0098.mockup.avionic-design.de>
 <201207030806.49561.arnd.bergmann@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline
In-Reply-To: <201207030806.49561.arnd.bergmann@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:kv5j63yPtnsrfKCyTysxjnz69lBZh/qs03/iL/qs00y
 rOlXUr/CQ5tbMl8NHcWL17o8R09DV7cqig4UJ6i9wrGZqPWdaQ
 OpyZ4n4j8e7d6xut2LwIPFuA3E476ll3wHF2TQC+T1iki79B3a
 KJzrZnDnSlGrvboscAf0iQOZmJjyczUpUCcouRb6jBCjm5/U8r
 Y8ExFT2CE0+3fNVxnUVCNzZmM6L0mney3wK96esu8IXHeyll4Y
 l1RG9SW6wRs4h+3yiCIxqFJkHE32OWv38LbZ2TLAeHOD+lQjb8
 t15KryoRA4XWt+xk0nu11w4l22Rh7Tp/1UNZzRXgCL7uuTaoBa
 JZDcWfLaveeAEetlM3NdNH2siZF5P4/yLXUAR96NXwhEtDqPfR
 udfFp08UhcZJrDz9ChrdnbhqnpGeYqEFU4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XF85m9dhOBO43t/C
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 03, 2012 at 08:06:49AM +0000, Arnd Bergmann wrote:
> On Tuesday 03 July 2012, Thierry Reding wrote:
> > On Tue, Jul 03, 2012 at 04:18:46PM +1000, Stephen Rothwell wrote:
> > > Hi Thierry,
> > >=20
> > > On Tue, 3 Jul 2012 08:11:15 +0200 Thierry Reding <thierry.reding@avio=
nic-design.de> wrote:
> > > >
> > > > I don't see how that can happen. If you have CONFIG_TWL6030_PWM=3Dy=
, then
> > > > you should also have CONFIG_HAVE_PWM=3Dy, which would in turn confl=
ict
> > > > with CONFIG_PWM=3Dy.
> > > >=20
> > > > I'll have to fetch a powerpc toolchain and try to reproduce this.
> > >=20
> > > CONFIG_HAVE_PWM only exists on arm, mips and unicore32 ... so the "se=
lect
> > > HAVE_PWM" will not do anything on any other architecture.
> >=20
> > So one option would be to add HAVE_PWM on powerpc, or alternatively to
> > explicitly add a conflict to the TWL6030_PWM symbol (and any others that
> > implement the legacy API). I'd think the second alternative is
> > preferable and actually matches what Arnd proposed previously. Maybe
> > this was exactly the reason he suggested that solution in the first
> > place.
>=20
> It's not what I was thinking of explicitly, but it's a good
> reason nonetheless ;-)

I came up with the attached patch. What do you think? It fixes the
PowerPC allyesconfig issue for me.

Thierry

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0001-pwm-Conflict-with-legacy-PWM-API.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 33859c48f1c771584312885bc37d14433bd2de7f Mon Sep 17 00:00:00 2001
=46rom: Thierry Reding <thierry.reding@avionic-design.de>
Date: Mon, 2 Jul 2012 21:29:45 +0200
Subject: [PATCH] pwm: Conflict with legacy PWM API

In order to avoid duplicate symbols with legacy PWM API implementations,
the new PWM framework needs to conflict with any of the existing legacy
implementations. This can be removed once all legacy implementations
have been moved to the PWM subsystem.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/pwm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 5227415..6e49f81 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -1,5 +1,6 @@
 menuconfig PWM
 	bool "PWM Support"
+	depends on !MACH_JZ4740 && !PUV3_NB0916 && !TWL6030_PWM && !AB8500_PWM
 	help
 	  This enables PWM support through the generic PWM framework.
 	  You only need to enable this, if you also want to enable
--=20
1.7.11.1


--CE+1k2dSO48ffgeK--

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP8qk6AAoJEN0jrNd/PrOhfG8P/izN8O9wjwFs0vxQKBVNrPTn
sV+dVZmDGsV7NrFWK7OFa1E4PKScxzKSIWMzOoF/s2qDbNfhAFDenlCLVtJDbvKz
udZEPGtfgxp4lL9ZYe/dVwKfgYqb+FJt+0cn7qhfhEQ6n7xZjawRmT+nBwea+7D8
PPRxbEvYIT37Y5S097/zUMm9A1Y2xsGd9qmwGXXVjKpHDkgUrq8J3ct+2RwVE6uG
wGSATGrdhcvueYbGVR8WxEv3WpX5UNcYGjB4aXyB864qxL7ctOYV5tVI9eEzKCzZ
Fg1xH6PbpAfadUf8JLfRMq0sMdLntZQAZ9hbPgmfEcHHZvrO5kJLPR6b7Jb2wHqy
IjjlZVNKNjKHZvj01lxGrkXGgdM10sPCnusJZc3H9RBZdGeruSJRl+4VnP6awDVf
AMOgNWJgMIQumxDj9IPV6a5qQBzao1Ujy6i23bf37AmC/vYmQ6jYprJrDy7EBzko
yN5U5OZhu30rkoh+Lr0vLm6APdux06//aBPkFPEfYC/2p3thUAV+9OkMsV3swOxb
I4xRs1A00rsYdr6tfIt3TvLiSe+UUGkgeH2DQChoXLggJh/JKxWow/7jB4W/eJwO
kUXlYydZtM6CrY8YSRszWckUG3Esaz+1cmh4VEqylcZBPl9zisNB5U6edF8mo/FN
VMj/LjPVHlzzixjtpEYj
=8RL8
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
