Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab1KYWsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 17:48:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36149 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab1KYWsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 17:48:45 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 8/9] bq27x00: Add miscdevice for each battery with ioctl for reading registers
Date: Fri, 25 Nov 2011 23:48:39 +0100
Message-ID: <2152198.K7Gf5EqrDF@pali-elitebook>
User-Agent: KMail/4.7.3 (Linux/3.2.0-1-generic; KDE/4.7.3; x86_64; ; )
In-Reply-To: <20111125220448.GA2078@oksana.dev.rtsoft.ru>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com> <33058541.3DK13LYaLI@pali-elitebook> <20111125220448.GA2078@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1335104.RcDibEA0X3"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1335104.RcDibEA0X3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Saturday 26 November 2011 02:04:48 Anton Vorontsov wrote:
> On Fri, Nov 25, 2011 at 09:54:04PM +0100, Pali Roh=E1r wrote:
> > On Saturday 26 November 2011 00:46:26 Anton Vorontsov wrote:
> > > On Fri, Nov 25, 2011 at 09:30:28PM +0100, Pali Roh=E1r wrote:
> > > [...]
> > >=20
> > > > This interface is not only for BME. Also some popular bq27200.s=
h
> > > > script which print bq registers in human readable form needs
> > > > this interface (with LD_PRELOAD library).
> > > >=20
> > > > Link for that shell script http://enivax.net/jk/n900/bq.tar
> > >=20
> > > That might be a good excuse to have the raw interface. Although,
> > > as this is for debugging purposes only, the same effect can be
> > > accomplished by unloading bq module and using i2c userspace
> > > interface directly... I guess.
> >=20
> > Yes, unloading bq module and then starting script working. But I th=
ink
> > that we could have some interface how to access directly to i2c whe=
n
> > some i2c module for chip is loaded.
>=20
> This would be not safe as this might (in case of RW registers)
> break kernel's driver behaviour (well, in bq case you only allow
> reading, so not problem in this particular case).
>=20
> What would be more practical, is to allow I2C core to provide
> userspace interface even for already bound I2C devices.
>=20
> That could be some kind of CONFIG_I2C_UNSAFE_DEBUG: when
> selected I2C core would allow access to all I2C devices. But still,
> the niche for such a feature is tiny, so I doubt that it is worth
> doing at all.
>=20
> In any case, I just think that being able to access already bound
> I2C devices from userspace might be a good thing for debugging,
> but having such an interface per-driver is impractical.
>=20
> Thanks,

Yes, you are right that per-driver access is bad. So I will use this io=
ctl=20
interface patch only in maemo specified kernels (eg. maemo kernel-power=
).

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart1335104.RcDibEA0X3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7QG0cACgkQi/DJPQPkQ1IPxgCfTiSsPUwMmpH51NC0tV3Ut+mn
ogoAn2gU4LncL881uEZWQaNpqpfK8MiL
=+9oS
-----END PGP SIGNATURE-----

--nextPart1335104.RcDibEA0X3--

