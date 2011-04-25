Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617Ab1DYMiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 08:38:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758275Ab1DYMiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 08:38:04 -0400
Message-ID: <4DB56B11.5090505@redhat.com>
Date: Mon, 25 Apr 2011 06:37:37 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Sunil Mushran <sunil.mushran@oracle.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christoph Hellwig <hch@infradead.org>,
        Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com> <20110422045054.GB17795@infradead.org> <20110422112852.GB1627@x4.trippels.de> <4DB16B72.1050702@redhat.com> <4DB1AC9D.3010706@oracle.com> <20110424174902.GA20461@shareable.org>
In-Reply-To: <20110424174902.GA20461@shareable.org>
X-Enigmail-Version: 1.1.2
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig63E171411ED8D35FBBBC4447"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig63E171411ED8D35FBBBC4447
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/24/2011 11:49 AM, Jamie Lokier wrote:
>> My problem with FIND_* is that we are messing with the well understood=

>> semantics of lseek().
>=20
> fcntl() looks a better fit for FIND_HOLE/DATA anyway.

With fcntl(), it would have to be something like:

off_t offset =3D start;
if (fcntl (fd, F_FIND_HOLE, &offset) !=3D 0)
    ; // find failed
// offset is now set to the next location after start

That is, offset has to be passed as an input _and_ output parameter,
since we can't use the int return value of fcntl to convey off_t
information, and since the optional third argument of fcntl has
traditionally been no wider than a pointer which is not the case for
off_t on 32-bit platforms.

--=20
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org


--------------enig63E171411ED8D35FBBBC4447
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJNtWsYAAoJEKeha0olJ0Nqf7gH/0BImPaIc8vsm6I7m1bKRQhN
0alusFYYi2BUbjnT1vTVZTaS2Sxzn6ZMVzh6VavMlawvB5ZaoT9jlwh7xmvD1nmJ
eXG51EQOFnaQvC1XnWx3+xukoxSoCPc1+KFSyA4VUOsV2OTKJ1gBlPYbhBlZFfFd
2pj/FXH9ZQF1aNZmPL13Ob174b8+stkQuTIt46hbedKbYdsYUYeV+Fcx8V99fRBE
b6Fer9jVYys3RWMZ8sRtSDQEM3tEnS/ip29GeqajRXwjGLzr4yXHyjj19fMHWCNJ
R18q7alt3o46nYlJtd0++MF9ywLUEz0j19i2AWjfcvxyKUyhZtmzeyTzca89Yiw=
=hmsN
-----END PGP SIGNATURE-----

--------------enig63E171411ED8D35FBBBC4447--
