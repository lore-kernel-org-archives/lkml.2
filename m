Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab1DVLu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 07:50:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab1DVLuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 07:50:22 -0400
Message-ID: <4DB16B72.1050702@redhat.com>
Date: Fri, 22 Apr 2011 05:50:10 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.9
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@toxicpanda.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com> <20110422045054.GB17795@infradead.org> <20110422112852.GB1627@x4.trippels.de>
In-Reply-To: <20110422112852.GB1627@x4.trippels.de>
X-Enigmail-Version: 1.1.2
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enigE4F8A2159243EA8EEB08BBD4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE4F8A2159243EA8EEB08BBD4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/22/2011 05:28 AM, Markus Trippelsdorf wrote:
> On 2011.04.22 at 00:50 -0400, Christoph Hellwig wrote:
>> [Eric: please don't drop the Cc list, thanks!]

That's the fault of gmane.  My apologies for not being subscribed in the
first place, and for gmane's refusal to cc all.  Now that I'm on the
cc-chain, it won't happen again for this thread.

>>> lseek's purpose is to reposition the file position, so I'd imagine
>>> this is just a bug in the man page.
>>
>> I would be surprised if the bug is around for such a long time, but
>> otherwise I concur.
>=20
> It's a bug. Let me quote what Jeff Bonwick wrote on his blog:
>=20
> =BBI'm not sure where you got the impression that either SEEK_HOLE or
> SEEK_DATA doesn't set the file pointer. They do. (If they didn't, that
> would be weird, and we'd call it out explicitly.)=AB
>=20
> http://blogs.sun.com/bonwick/entry/seek_hole_and_seek_data

That blog also mentioned the useful idea of adding FIND_HOLE and
FIND_DATA, not implemented in Solaris, but which could easily be
provided as additional lseek constants in Linux to locate the start of
the next chunk without repositioning and which could ease application
programmer's life a bit.  After all, cp wants to know where data ends
without repositioning (FIND_HOLE), read() that much data which
repositions in the process, then skip to the next chunk of data
(SEEK_DATA) - two lseek() calls per iteration if we have 4 constants,
but 3 per iteration if we only have SEEK_HOLE and have to manually rewind=
=2E

--=20
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org


--------------enigE4F8A2159243EA8EEB08BBD4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJNsWtyAAoJEKeha0olJ0NqjwYIAJNlhTuBqcUgFLiF/EafpVwP
6yZalaWoR7AkvSlXE08oOV/qp3J1P5NrT1IEMItsk/3EABtLHncxb3EK3UmJEqyB
wlU0dmod/jbdi8f+wvqNR6eUKA+No28f1IbhenOtXTvlDNPdc9sz45NegNglvKeB
t/gaRZGKc1fv4v84CirdGntB5UqWwduQXnOV/5DFHGNNN2ZpqrbsyR8UcvD3KTSY
CoLeXCkm7Cj23sfmCi9FWs+WGZ1JPVTLIAU57Q1EkVxxet8q9uvhx1etnFtmNUrL
p9sd/Xaz+LcQT+wl5hVZUNUEOqfFQ2rd9m4DQGRl3O1SZIIIOv6pI53/8+yXXMs=
=FUqo
-----END PGP SIGNATURE-----

--------------enigE4F8A2159243EA8EEB08BBD4--
