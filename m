Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2IMGmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:42:35 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:44240 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755935Ab2IMGmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:42:31 -0400
Message-ID: <1347518544.7471.36.camel@lappyti>
Subject: Re: [PATCH v6 0/4] Runtime Interpreted Power Sequences
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Thu, 13 Sep 2012 09:42:24 +0300
In-Reply-To: <1749811.4qrG1GZfBf@percival>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
	 <1347515447.7471.12.camel@lappyti> <1749811.4qrG1GZfBf@percival>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-J9R+j9MFw8FGun1NadAu"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-J9R+j9MFw8FGun1NadAu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-13 at 15:23 +0900, Alex Courbot wrote:
> On Thursday 13 September 2012 13:50:47 Tomi Valkeinen wrote:

> > I want to reiterate my opinion that I think power sequences in DT data
> > is the wrong way to go. Powering sequences are device specific issues
> > and should be handled in the device driver. But I also think that power
> > sequences inside the drivers would probably be useful.
>=20
> I understand the logic behind handling powering sequences in the device=
=20
> driver, but as we discussed for some classes of devices this might just n=
ot=20
> scale. I don't know how many different panels (each with different poweri=
ng=20
> sequences) are relying on pwm_backlight, but the alternative of embedding=
=20
> support for all of them into the kernel (and bloating the kernel image) o=
r=20
> having a 3 kilometers list in the kernel configuration to individually ch=
ose=20
> which panel to support (which would be cumbersome and make the kernel les=
s=20
> portable across boards) does not look much appealing to me. With power=
=20
> sequences encoded in the DT, we could have one .dtsi file per panel that =
would=20
> be included from the board's .dts file - no bloat, no drivers explosion,=
=20
> portability preserved.

Yes, I see that side of the argument also. And to be honest, I don't
know what kind of data is DT supposed to contain (or if there even is a
strict definition for that).

I have my opinion because I think that's how things should be: DT tells
us what devices there are and how they connect, and the driver handles
the rest. I may be a perfectionist, though, which is not good =3D).

As for the kernel bloat, it's a valid issue, but I wonder if it would be
an issue in practice. I don't know how many different supported devices
we'd have, and how many bytes the data for each device would consume.
I'm not even sure what amount of bytes would be acceptable.

But I'm guessing that we wouldn't have very many devices, and if the per
device data is made compact there wouldn't be that many bytes per
device. And with non-hotpluggable platform devices the unused device
data could be discarded after init.

Anyway, having the power sequences doesn't affect me if I don't use
them, so I have nothing against them =3D).

> DT support is actually the main point of power sequences, as outside of t=
he DT=20
> we can always work the old way and use callbacks. If we were to remove DT=
=20
> support, I am not sure this work would still be worth being merged.

We can't use board callbacks when running with a DT enabled kernel. What
I meant is that the driver could contain a power sequence for the device
(or multiple supported devices). So it'd essentially be the same as
getting the power sequence from the DT data.

But I haven't looked at the power sequence data structures, so I'm not
sure if they are geared for DT use. If so, they would probably need
tuning to be good for in-kernel use.

 Tomi


--=-J9R+j9MFw8FGun1NadAu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQUYBQAAoJEPo9qoy8lh71V8oP/3MqcLTN3YerDm9XljAIYeL4
I0eTqMjEE45AEr1hJPIuWkKHYZuMtxe4oDQzcQ5KY3GRdCLkSTMYFFkViwg6KQMI
zV540wuwPalXsrj67OhCfM7Vdrzc19O6gjtJ4hmstYIvJyEo+HwOqhf+21Dqoqfd
ob/lgTg4q5fHp4KM7gRcSYxS9IqSgcp5EqW6hEniyzVj+Sw/eje1gq2EvwxwY+Kt
YNwN+Mwp8LGWe9Kq6E6Iu1rYAg0fjQpsgCDpQBKQ+3mHJspPp95mzsjYNLLeQQ2O
tDzWFJtk9fkcOLnJXOi/qqIGR9rP/vp69LBzv9P43N80huhJL9C5RFZRqO650bX6
/7CQJ91OfhEghKILbWZN0eCa++mZsbW+z1H6qtX+bL7Qf+clWzgfXenY2mwN5szp
1nKKVTn/jNEaTZDt2ZkUyltiYie1wX25Uxtd8q6LMGdFDdbimn9vN2TS9gkCu884
UrJIRyTvo0QJESgot3s6vhVZTpfgfrnjl0Q2Gur1ZgZAr/XYyksrUxlvNjkvoQxp
4ZXuxXsel3wgVAilaeTrJExQ/yC7LoyW5Zr16r2cfopJq3rM83qKfFtMCSu2deVG
6J1kVM5CfB7qxcxNhlVgzNns0PnCkJF5uo/weT5Faad6yqUkxfZ8H2mrw4eNno5X
LDnWgT5/PyEOHnNnJ1xk
=hubs
-----END PGP SIGNATURE-----

--=-J9R+j9MFw8FGun1NadAu--

