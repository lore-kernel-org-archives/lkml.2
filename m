Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab1AYT4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:56:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab1AYT4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:56:30 -0500
Message-ID: <4D3F2AD9.8060000@redhat.com>
Date: Tue, 25 Jan 2011 12:56:09 -0700
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Arnd Bergmann <arnd@arndb.de>, Paul Eggert <eggert@cs.ucla.edu>,
        Roland McGrath <roland@redhat.com>, linasvepstas@gmail.com,
        Chris Metcalf <cmetcalf@tilera.com>,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        libc-ports@sourceware.org, linux-api@vger.kernel.org
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com> <20110125174515.C1DC2183C19@magilla.sf.frob.com> <201101251921.15184.arnd@arndb.de> <201101251352.03079.vapier@gentoo.org>
In-Reply-To: <201101251352.03079.vapier@gentoo.org>
X-Enigmail-Version: 1.1.2
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig2D5DE2101AF40D904450289D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2D5DE2101AF40D904450289D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/25/2011 11:52 AM, Mike Frysinger wrote:
> On Tuesday, January 25, 2011 13:21:14 Arnd Bergmann wrote:
>> On Tuesday 25 January 2011 18:45:15 Roland McGrath wrote:
>>>  I know of no reason to
>>>
>>> think that the current treatment of the empty string was ever intende=
d at
>>> the creation of the *at interfaces.
>>
>> I always assumed that this was done so that the *at syscalls can repla=
ce
>> both the ones that take a file descriptor (e.g. fstat) and the ones th=
at
>> take a pathname (e.g. stat), which is sensible for the non-AT_FDCWD ca=
se,
>> although not documented in the man pages.

For futimesat, which is not specified by POSIX, gnulib already requires
the behavior of calling futimesat(fd, NULL, times) as a way to directly
modify the (possibly non-directory) fd, in contrast to futimesat(fd,
"name", times), which sets the times on "name" relative to the directory =
fd.

For all other *at interfaces, they are specified by POSIX as requiring
the same behavior as the non-*at interface when given arguments within
the bounds required by POSIX.  That is, fstatat(fd, "", buf, 0) SHALL
fail with ENOENT, just the same as stat("", buf).  However, since POSIX
requires that the second argument be a valid string, and NULL is not a
valid string, then passing NULL as the second argument means that you
are no longer bound by POSIX and that you could (if you wanted) make
fstatat(fd, NULL, buf, 0) behave the same as fstat(fd, buf).  Right now,
none of the other *at interfaces in Linux currently do this; futimesat
is the only interface explicitly documented as having this dual behavior.=


>>
>> Treating the empty string special for AT_FDCWD is rather pointless, bu=
t
>> at least consistent.

No, treating an empty string name argument to a *at function as a
synonym for AT_FDCWD is a violation of POSIX.

> i dont know if the gnulib peeps are on these lists, but i think their=20
> implementations of some of the *at funcs leverage the extended behavior=
 that=20
> is available under Linux.  or at least, i'm certain they'll have some i=
nsight=20
> into some of these nuances.

Gnulib has code to explicitly work around bugs in earlier glibc/Linux
implementations that mistakenly treated fd, "" the same as fd, "." (at
least modern kernels get it right, and when glibc defers to the kernel,
those workarounds in gnulib are not needed on newer systems).

--=20
Eric Blake   eblake@redhat.com    +1-801-349-2682
Libvirt virtualization library http://libvirt.org


--------------enig2D5DE2101AF40D904450289D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJNPyrZAAoJEKeha0olJ0Nq5bQH/29LIEO5FU5nkAqRbmdz+tzO
pce/CECUYOgPBnUuKRUCFusz5MkUmzpVxhZm8fDgdvzSXBTFK8Q7S3/jV86wuMwc
vkuTL9RbKHZu9F24f5d2O/4hWJlntJSFvthvNppVB5iEAuvaKbjlC5o9y2fTkrDm
dwlh/1LWvvOMeDZ8m7z8ZoEY7SEo47Jjx1gunjgFWlp4SehqUwyfnkdiCDmkYGP9
XIrQRNfMqI1YVXkQO1wSIDbvigZ02CcWv9VoDonR2kzSNAh4hXgxZKTJx/Z2wiy8
jD6OfPGtYmz9kATUet86ISdtt6IUJwpOQB3b8eJgEcyReIYOzauyhIhCIC36XNA=
=VUVd
-----END PGP SIGNATURE-----

--------------enig2D5DE2101AF40D904450289D--
