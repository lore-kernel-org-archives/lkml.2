Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab1DYPtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 11:49:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab1DYPtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 11:49:08 -0400
Message-ID: <4DB597E3.7090600@redhat.com>
Date: Mon, 25 Apr 2011 09:48:51 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.9
MIME-Version: 1.0
To: Nick Bowler <nbowler@elliptictech.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christoph Hellwig <hch@infradead.org>,
        Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Coreutils <coreutils@gnu.org>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com> <20110422045054.GB17795@infradead.org> <20110422112852.GB1627@x4.trippels.de> <4DB17D5B.2090303@redhat.com> <20110425150227.GA10653@elliptictech.com>
In-Reply-To: <20110425150227.GA10653@elliptictech.com>
X-Enigmail-Version: 1.1.2
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig8B7BBB404659570B8A8ECBF7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8B7BBB404659570B8A8ECBF7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/25/2011 09:02 AM, Nick Bowler wrote:

Hi Nick,
> * File A (sparse file created by lseek/write beyond end-of-file):
>=20
>     data | hole 0 | data || hole 1 (virtual)
>=20
> * File B (sparse file created by truncate beyond end-of-file):
>=20
>     data | hole 0 || hole 1 (virtual)
>=20
> Excluding the error description, the term "the last hole" is used in
> two places in your proposal:
>=20
>   * (for SEEK_HOLE): if offset falls within "the last hole", then the
>     file offset may be set to the file size instead.
>=20
>   * (for SEEK_DATA): it shall be an error ... if offset falls within th=
e
>     last hole.
>=20
> I imagine that both of these conditions are intended to address the
> case where the offset falls within hole 0 in File B, that is, when
> there is no non-hole data beyond the specified offset but the offset
> is nevertheless less than the file size.

Correct.

>  However, this looks (to me)
> like the penultimate hole in the file, not the last hole.  Furthermore,=

> these conditions are presumably *not* intended to apply to the
> penultimate hole in File A, which has data after it.

Good catch.

>=20
> I think my confusion can be avoided by talking about the last non-hole
> data byte in the file (which is unambigious), instead of by talking
> about the last hole.  For instance, the SEEK_HOLE/SEEK_DATA description=
s
> could be written as follows:
>=20
>   If whence is SEEK_HOLE, the file offset shall be set to the smallest
>   location of a byte within a hole and not less than offset, except tha=
t
>   if offset falls beyond the last byte not within a hole, then the file=

>   offset may be set to the file size instead.  It shall be an error if
>   offset is greater or equal to the size of the file.
>=20
>   If whence is SEEK_DATA, the file offset shall be set to the smallest
>   location of a byte not within a hole and not less than offset.  It sh=
all
>   be an error if no such byte exists.
>=20
> plus a corresponding update to the ENXIO description:
>=20
>   ... or the whence argument is SEEK_DATA and the offset falls beyond
>   the last byte not within a hole.

I've added your improved wording as a comment at
http://austingroupbugs.net/view.php?id=3D415

--=20
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org


--------------enig8B7BBB404659570B8A8ECBF7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJNtZfjAAoJEKeha0olJ0NqQWgIAIRdXY+1Os6dnyI7OfkncGmz
/4+2wNGUBmXtEdOn52oCOfe3gp0zP6s6SbIWAz80P72pcTMzxDIjFjc3kmHRY+64
LHFxRS3pIDRDfLmqyI7w1H89qfbRi8Gem9jAoF6BPeuhcfu0MQ27+9K4byXxrhTU
lzFEGTHHUH6QC4mS+qS9YIgPUZKnipOIFRJPDDzeJKFuElDpGvUFF7TyyR9eGKXb
bh0sZSXMfhyd5oVp08pk6OBJBfMRF1Z3ysArWOng5QoJ7cttYcjc7u+D98Bi5GXS
ijofbM6/qDFt/W2NJ+W22U/7TIvKz9EkiAir3MGFYcXqWN/eGmOECf2p2biQhOs=
=qasl
-----END PGP SIGNATURE-----

--------------enig8B7BBB404659570B8A8ECBF7--
