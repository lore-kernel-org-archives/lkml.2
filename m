Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2EUXTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:19:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53738 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2EUXTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:19:30 -0400
Date: Tue, 22 May 2012 09:19:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: <linux-next@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <plagnioj@jcrosoft.com>,
        <maxime.ripard@free-electrons.com>, <olof@lixom.net>
Subject: Re: [PATCH] ARM: at91: Add ADC driver to at91sam9260/at91sam9g20
 dtsi files
Message-Id: <20120522091925.a77c21afb66e52749157b86e@canb.auug.org.au>
In-Reply-To: <4FBA1483.4010008@atmel.com>
References: <4FB3B1F3.6080102@atmel.com>
	<1337182626-13033-1-git-send-email-nicolas.ferre@atmel.com>
	<201205161850.54765.arnd@arndb.de>
	<20120517150601.GA28104@kroah.com>
	<20120518084446.a7b229074ea215fd7bcd1eb8@canb.auug.org.au>
	<4FBA1483.4010008@atmel.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_09_19_25_+1000_edbCXuva69fhWXc+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_09_19_25_+1000_edbCXuva69fhWXc+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicolas,

On Mon, 21 May 2012 12:10:11 +0200 Nicolas Ferre <nicolas.ferre@atmel.com> =
wrote:
>
> After checking the current status of
> arch/arm/boot/dts/at91sam9g20.dtsi in linux-next, it seems the merge
> resolution has not produced a good result:
>=20
> The "adc0" node, should only look like:
>=20
> ahb {
>         apb {
>                 adc0: adc@fffe0000 {
>                         atmel,adc-startup-time =3D <40>;
>                 };
>         };
> };
>=20
> without the redundant code carried by the staging git tree. In short,
> the arm-soc version is the proper one.

Rats!  That was an automatic merge resolution and I didn't even notice,
sorry.  I will fix it up today in linux-next, but someone needs to
remember to tell Linus when the second if these two trees is merged.

I will apply the following as a merge fixup patch after merging the
arm-soc tree (which comes later in my sequence):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 22 May 2012 09:17:31 +1000
Subject: [PATCH] ARM:at91: merge fixup for dtsi file

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/boot/dts/at91sam9g20.dtsi |   35 --------------------------------=
---
 1 file changed, 35 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9g20.dtsi b/arch/arm/boot/dts/at91sam=
9g20.dtsi
index 06ca15b..2a1d1ca 100644
--- a/arch/arm/boot/dts/at91sam9g20.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20.dtsi
@@ -21,41 +21,6 @@
 			adc0: adc@fffe0000 {
 				atmel,adc-startup-time =3D <40>;
 			};
-
-			adc0: adc@fffe0000 {
-				compatible =3D "atmel,at91sam9260-adc";
-				reg =3D <0xfffe0000 0x100>;
-				interrupts =3D <5 4>;
-				atmel,adc-use-external-triggers;
-				atmel,adc-channels-used =3D <0xf>;
-				atmel,adc-vref =3D <3300>;
-				atmel,adc-num-channels =3D <4>;
-				atmel,adc-startup-time =3D <10>;
-				atmel,adc-channel-base =3D <0x30>;
-				atmel,adc-drdy-mask =3D <0x10000>;
-				atmel,adc-status-register =3D <0x1c>;
-				atmel,adc-trigger-register =3D <0x04>;
-
-				trigger@0 {
-					trigger-name =3D "timer-counter-0";
-					trigger-value =3D <0x1>;
-				};
-				trigger@1 {
-					trigger-name =3D "timer-counter-1";
-					trigger-value =3D <0x3>;
-				};
-
-				trigger@2 {
-					trigger-name =3D "timer-counter-2";
-					trigger-value =3D <0x5>;
-				};
-
-				trigger@3 {
-					trigger-name =3D "external";
-					trigger-value =3D <0x13>;
-					trigger-external;
-				};
-			};
 		};
 	};
 };
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_May_2012_09_19_25_+1000_edbCXuva69fhWXc+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPus19AAoJEECxmPOUX5FEMjMP/ReRbV1rUSwaLhnjMsCdJ8Ib
ulxBkmrgyJEM868VvdJY0OWy32Q4WOPVhR9srPJmGXQECF4Hw0B6YvJmg4GNrNyN
K8PJFesGfbeI1MFNaDQbgDSAzEy6rHNrKdk7t34G6sLWBk3KG4bwCJPOfTKI511F
qvWTU7b6tnGpHdzjkMZSBr+rF9om/qgWKuDLdWHxeJU2rbjOMhL4jUavA75YShDv
3NBSMQWzmoBpTI9XGEfBq1YjBpzWQgGdb8DuEPPITS4+CdZZRdiwsfpk+kSZF9Hj
xQU3i3H71onL5TCXL55xUXB7KXsyxGl9hPHP5rZNkys9cz/7w7cEHfvIlaEvHddy
cycKrCwSA5C4gHuORrZk7iWu2OBk1hMqiNh0psmWqtOCi0kPl9H4oBLXvUfN4xhm
n/vYS1AgZ3KPLL02CroSCOCbIVRv0JXfAfmQ1VSDtCe9pYqz1Gu2Y41LrZJGYDfN
or4nKAiVv4Jv+x4hiy1nr6K55Qqo7dECr9okXtg+GS/FxZ7IzYEYiQwc9Mb9eNXL
kHqBubsj7+0m0MYg3oFhoPE5cWDwFY1w7Sj0t28J9c/wT2YQ9bRgpeSP9Fv7uIUI
TyD9zvuxjZfd01jeDznwOWeOGTuU9fPGs54ufzNYkrxbZbsqeuXdtRP5uQH406t2
WJqrY88Ny3lbOGmojfUd
=LMsC
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_09_19_25_+1000_edbCXuva69fhWXc+--
