Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0LZXuD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 18:50:03 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49770 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab0LZXuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 18:50:00 -0500
Date: Mon, 27 Dec 2010 10:49:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Takashi Iwai <tiwai@suse.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the sound tree (Was: Re:
 linux-next: build failure after merge of the sound-asoc tree)
Message-Id: <20101227104951.1ecad371.sfr@canb.auug.org.au>
In-Reply-To: <20101223021212.GA25886@opensource.wolfsonmicro.com>
References: <20101223120243.1617cd40.sfr@canb.auug.org.au>
	<20101223021212.GA25886@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__27_Dec_2010_10_49_51_+1100_NF_FS39b_jOabQum"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Dec_2010_10_49_51_+1100_NF_FS39b_jOabQum
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Thu, 23 Dec 2010 02:12:12 +0000 Mark Brown <broonie@opensource.wolfsonmi=
cro.com> wrote:
>
> On Thu, Dec 23, 2010 at 12:02:43PM +1100, Stephen Rothwell wrote:
>=20
> > After merging the sound-asoc tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
>=20
> > ERROR: "__tracepoint_snd_soc_jack_irq" [sound/soc/codecs/snd-soc-wm8962=
.ko] undefined!
> > ERROR: "__tracepoint_snd_soc_jack_irq" [sound/soc/codecs/snd-soc-wm8903=
.ko] undefined!
>=20
> > Caused by commit 1c9e9795b5e2348df619fd6010d7583dc9b8c811 ("ASoC: Add
> > jack IRQ trace to 88pm860x driver").
>=20
> It's not that commit - that's for a totally different driver to those

Yeah, I just picked on a semi-obvious commit in my rush.

> above which can't build on x86 as x86 lacks generic hardirqs.  I've
> pushed up a change which ifdefs out all the tracepoints when things are
> built modular, but it seems unfortunate that x86 isn't doing the right
> thing here, whatever ARM is doing seems to DTRT.

The first of those errors is now present in the sound tree, so I have
used the version of the sound tree that would have been in next-20101223
if I had released it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__27_Dec_2010_10_49_51_+1100_NF_FS39b_jOabQum
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNF9SfAAoJEDMEi1NhKgbs0KgH/2W/706KWtki6clfzUDv60od
sLGTiMX2DAcNyNGILQSDlmqB2CPCkOSvKu+mf8UO1AQjAhyVVmT/H87jDCzDt0CD
vlDZv9lrvu4+FjreEbVA297izbauMTitsr6SOIUkPgbjfVyFD5PHC2MJxaGtz+rC
RyDZ+CGnGLF7HCDIasN1Z5RapJeaj/IQS3EmFKe6zg5iSMBAJ2FocQ4D57spQQ7A
2xSV4+EN+C8M4sSBXXmRryq8cs90acjiUZpgdISnxz7TF/gG71e0gToCtdorhAgy
YzHBwV6tUVQVVeeVjIPS9lc3/nfYZho318e2rR3O+wfWVnAyUB64XrOg+Ty47Ak=
=340N
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Dec_2010_10_49_51_+1100_NF_FS39b_jOabQum--
