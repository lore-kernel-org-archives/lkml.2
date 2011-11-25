Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1KYUaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 15:30:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53616 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1KYUae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 15:30:34 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 8/9] bq27x00: Add miscdevice for each battery with ioctl for reading registers
Date: Fri, 25 Nov 2011 21:30:28 +0100
Message-ID: <7780165.E3DXgdWAv1@pali-elitebook>
User-Agent: KMail/4.7.3 (Linux/3.2.0-1-generic; KDE/4.7.3; x86_64; ; )
In-Reply-To: <20111125201011.GA14217@oksana.dev.rtsoft.ru>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com> <CAHYPw2F3mYD2R4C_XCDc6wBbsEfz_wscEGdmHONhKRr9jbeEaw@mail.gmail.com> <20111125201011.GA14217@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2250936.Wg3QI4pDok"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2250936.Wg3QI4pDok
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Saturday 26 November 2011 00:10:11 you wrote:
> Hello Pali,

Hello,

>=20
> On Tue, Nov 01, 2011 at 01:53:26PM +0100, Pali Roh=E1r wrote:
> [...]
>=20
> > >> Also on Nokia N900 is needed proprietary pogram BME for
> > >> battery charging which need to access to bq27200 registers. A
> > >> simple
> > >> LD_PRELOAD library which wrap i2c-dev access to this device
> > >> provided
> > >> by this patch is here:
> > >> https://code.launchpad.net/~pali/+junk/maemo_libbqioctl
> > >=20
> > > Yes, but that really is a hack to work around the closed source
> > > nature of the BME program. I don't think we should put such hacks=

> > > into the kernel.>=20
> > Not only BME. All programs (and shell scripts and all which use
> > i2cget) need this interface, bacuse loading bq module will block
> > ic2-dev.
>=20
> A million thanks for your work! Though, on this particular patch I
> agree with Lars-Peter here. The raw abi interface ought to exist only=

> because proprietary nature of BME, which is not good.

This interface is not only for BME. Also some popular bq27200.sh script=
 which=20
print bq registers in human readable form needs this interface (with=20=

LD_PRELOAD library).

Link for that shell script http://enivax.net/jk/n900/bq.tar

>=20
> IIRC, there is some shell script that makes it possible to charge
> N900 without BME?

bq27200 chip is for retrieving informations about battery. Chip bq24150=
 is=20
responsible for charging battery. And yes, there is shell script which =
use=20
this chip and can charge N900 battery (when BME is stopped).

Link: http://enivax.net/jk/n900/charge21.sh.txt

Problem is that this charge script need access to bq27200 registers too=
 and=20
the only way is again rmmod bq27x00_battery driver or using that my int=
erface.

> Is it possible to convert it to some "n900 charger driver"?

And two hours ago I started writing kernel driver for chip bq2415x whic=
h will=20
support charging battery. So I think yes!

So I think, one day I will delete BME from my Nokia N900.

>=20
> I applied all patches from this series, except this one.
>=20
> Thanks,

Ok, thanks!

I need some interface from userspace which can access to bq27200 regist=
ers.=20
Problem is that if driver bq27x00_battery is loaded it is not possible =
to=20
access to registers via i2c-tools. If this patch is not acceptable to=20=

upstream, what is solution to this problem? I think that it is not good=
 idea=20
to rmmod bq27x00_batery driver before executing scripts and then modpro=
bing it=20
again...

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart2250936.Wg3QI4pDok
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7P+uQACgkQi/DJPQPkQ1IwWQCgmohblvTAaZEdQe2p5GVQERqa
ElUAoLK88BMm68+Je/HBSiQSdcHjhuS1
=yAbc
-----END PGP SIGNATURE-----

--nextPart2250936.Wg3QI4pDok--

