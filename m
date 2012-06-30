Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2F3Kxd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 06:53:33 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402Ab2F3Kxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 06:53:31 -0400
Message-ID: <4FEEDAA4.30105@nod.at>
Date: Sat, 30 Jun 2012 12:53:24 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind1@gmail.com>
CC: linux-mtd@lists.infradead.org, nyoushchenko@mvista.com,
        artem.bityutskiy@linux.intel.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, Marius.Mazarel@ugal.ro, tim.bird@am.sony.com
Subject: Re: UBI fastmap updates
References: <1340982869-77042-1-git-send-email-richard@nod.at> <1341052998.2115.3.camel@koala>
In-Reply-To: <1341052998.2115.3.camel@koala>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1E0B4ACC93B4DA769162340A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1E0B4ACC93B4DA769162340A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 30.06.2012 12:43, schrieb Artem Bityutskiy:
> On Fri, 2012-06-29 at 17:14 +0200, Richard Weinberger wrote:
>> This is the next round of UBI fastmap updates.
>>
>> Fastmap is now disabled by default.
>> If you attach an image it will not automatically convert it
>> to the fastmap format.
>> UBI has a new module parameter "fm_auto".
>> If set to 1 UBI will create a fastmap automatically on your
>> flash device.
>> Please see commit "Add a module parameter to enable fastmap"
>> for more details.
>=20
> One thing I've noticed is that you use vmalloc for some of the buffers
> you do I/O on (fm_raw). This is a problem for many ARM platforms becaus=
e
> they cannot do DMA on such buffers. The drivers have to implement
> various workarouns for this: either fall back to memcopies or do an
> extra copy to a DMA-able buffers.
>=20
> UBI and UBIFS already to I/O on vmalloc'ed buffers, an I am planning to=

> fix this, which is not easy. Would be great to not add more of these.

There are only two buffers which use vmalloc() both are used to hold the =
raw fastmap and have
the same size.
If it helps I could preallocate a buffer in ubi-> and use it in both func=
tions ubi_write_fastmap()
and ubi_scan_fastmap().

So basically you want me to get rid of any vmalloc()'ed buffer?
That's not easy.

Thanks,
//richard


--------------enig1E0B4ACC93B4DA769162340A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJP7tqkAAoJEN9758yqZn9eQucIAKrqW0rIwlG4h3taeW/2hVS+
zBkmEbHl8nieU0HJGKUvYU6bAQkidaYuADr15rLol7St5tojkZJ4ciOsfYirgqa8
9c5Wa7ruEOMemhPa678Uw3mqwQytHcmbxHY7PY9zRv42DteemtEm2X1R6VbC6B2T
QKgv0lwMhLLObREVdgWcKJsTzYFQ5CewkSCXGG5A9e6oNCIBA8ixL3v+SqPbzoBv
II7ykDcxs0pU6hKUOW+zBsnspbyXKuhhINKwTp3gGeaF5cXr4pAgvxSVrMyoDyuP
gPHGT9ZRVxJZKVsGW4zu3Hgwpb02tRAwNI+KTloA/NoscU7XNbBAspDFPDBjB7k=
=Ih86
-----END PGP SIGNATURE-----

--------------enig1E0B4ACC93B4DA769162340A--
