Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab2HPJyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 05:54:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55052 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab2HPJyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 05:54:51 -0400
Date: Thu, 16 Aug 2012 11:54:39 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Borislav Petkov <bp@alien8.de>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: awful kconfig help texts.
Message-ID: <20120816095439.GA30794@avionic-0098.mockup.avionic-design.de>
References: <20120731151600.GA19412@redhat.com>
 <20120731170741.GA4735@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <20120731170741.GA4735@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:zZcz2DnZfysorPMQcfYYs17ATfZH9YlbCu1XOnOoqFS
 RnsHdlZhQbo5MspoD88FlGP8Hdh9RBGJc0ftnO+unZfwwRZcTi
 /BTxWEu6rzIc0UnX6CziTCJgAdHQ4zfkPnc3BagaulJEB5UiX9
 Qcp6gwCT3gAg3LtcEyCqZvnHycJCnUec3I0o8KyMsoXpuhE8Wf
 mgNb0VLwAFudMGq3sNeXj93SkpVn5OC82T2umaeOyQKrLa7j4N
 Sp6UGwRWE6/gFifhFgg5FCLxnskWr0UfaCYTb2IkPNSO1LXfWV
 eL6EW/H66zYWr3+NhnMmRMRWr3u93LdIeSFn8HO46g+pKHZSp3
 0Qjwvnla9PXIHjlYtYQ312QJbMOh6pS1gibfmwg3M2TLic5lXY
 QqDKEljRUWJpqNB6l4d3CAf/72n6OTY3RY7iLOjPMrPYE2uiUr
 o8aD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 31, 2012 at 07:07:41PM +0200, Borislav Petkov wrote:
> On Tue, Jul 31, 2012 at 11:16:00AM -0400, Dave Jones wrote:
> >=20
> > PWM Support (PWM) [N/y/?] (NEW) ?
> >=20
> > CONFIG_PWM:
> >=20
> > This enables PWM support through the generic PWM framework.
> >=20
> >=20
> > Well that's.. enlightening.
>=20
> Oh, there's one more enlightening sentence in the help:
>=20
> "You only need to enable this, if you also want to enable one or more of
> the PWM drivers below."
>=20
> Got it? :-)
>=20
> > I'm picking on PWM here, but this isn't an
> > isolated case.  Every merge window we see a slew of new options with us=
eless
> > help texts. They may as well be non-existent. (Actually in some cases, =
they are).
> >=20
> > If someone has to read the code to find out what the driver is, your he=
lp text probably sucks.
> >=20
> >=20
> > (I'll leave "why does this option even show up on x86" as a separate ra=
nt)
>=20
> Thierry, can you guys please fix this?

How does the attached patch look?

Thierry

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0001-pwm-Improve-Kconfig-help-text.patch"
Content-Transfer-Encoding: quoted-printable

=46rom cd3199b94e697cccd38766b4a60d2e91474d0539 Mon Sep 17 00:00:00 2001
=46rom: Thierry Reding <thierry.reding@avionic-design.de>
Date: Thu, 16 Aug 2012 08:01:21 +0200
Subject: [PATCH] pwm: Improve Kconfig help text

The Kconfig help text should help the user understand what functionality
is provided by an option. This is especially true for new subsystems. An
improved help text is provided by this commit in the hopes of clarifying
the usefulness of the PWM framework.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/pwm/Kconfig | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
index 8fc3808..88ddb9e 100644
--- a/drivers/pwm/Kconfig
+++ b/drivers/pwm/Kconfig
@@ -1,12 +1,24 @@
 menuconfig PWM
-	bool "PWM Support"
+	bool "Pulse-Width Modulation (PWM) Support"
 	depends on !MACH_JZ4740 && !PUV3_PWM
 	help
-	  This enables PWM support through the generic PWM framework.
-	  You only need to enable this, if you also want to enable
-	  one or more of the PWM drivers below.
-
-	  If unsure, say N.
+	  Generic Pulse-Width Modulation (PWM) support.
+
+	  This framework provides a generic interface to PWM devices
+	  within the Linux kernel. On the driver side it provides an API
+	  to register and unregister a PWM chip, an abstraction of a PWM
+	  controller, that supports one or more PWM devices. Client
+	  drivers can request PWM devices and use the generic framework
+	  to configure as well as enable and disable them.
+
+	  The new generic framework replaces the legacy PWM framework
+	  which allows only a single driver implementing the required
+	  API. Not all legacy implementations have been ported to the
+	  new framework yet. The new framework provides an API that is
+	  backward compatible with the legacy framework so that existing
+	  client drivers continue to work as expected.
+
+	  If unsure, say no.
=20
 if PWM
=20
--=20
1.7.11.5


--M9NhX3UHpAaciwkO--

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQLMNfAAoJEN0jrNd/PrOhs8IQAL8VslY8+lD6lJ0AEqHvJzPN
tTX5Ro7PbYJuyI4bvniQH/7+HoB0hdOGjjX/iJJBWSs80uRVdCiEyOZPfaPQDew0
NTf6dP+d9IWBpHm0amN0SzzuhrIVWOKH1PxstGlSvEoAOGJh/r5WQkbvbeElQovx
H0iat+vHcP+f4i3+f3sEU/25SBuGNdCbq+EZxavRMuYFFTeuBkf1kUQf7hDk2SwK
vaglIbqAuDrKbSKYO33S9v799nfVFultjV1/F1T7wdvl9lHg3KUhyOaIhs8l9wpY
hniAMyHnFOFuewzrjKhRBrwJzrVujfBBUCevGgzoP2Hamau2BBKMX1wT/gcj+kfR
jKXmJ0fw0rHZ0HlBni+a/aVACNFjHzw9fm+JcX1i91ZpnFPj7piNXenNs5kQBeXj
met1Vy8pWNtN/KiVqbmNRbD3ve1QI/8Js6sqhwtNMqxA+5edi7swVNFOZiJUKY+p
Ca+Pes9P/BPdQQIBpIDpr3Y4B4Ffru/88L1brpASzM5JrsAgCq7eYNnSJEWijPsO
HLw2vJ5aEmL+QsCiNbA2Mjm8LuRXVosgcFAyhphrmJAHWWj7mgv3gifneTDnYI4T
SAfFvW9pGnNCBtRlDL37byr54QS3wgzhD5s+lQpsUfZdpqzUVslKfzReLITN4Den
gMNoqezig47nYPkxBbYE
=utF5
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
