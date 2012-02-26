Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab2BZEht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 23:37:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51934 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747Ab2BZEhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 23:37:48 -0500
Message-ID: <1330231055.8460.26.camel@deadeye>
Subject: Re: Bug#661193: linux-tools-3.2: perf fails to annotate code with
 separate debug info under some conditions
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: 661193@bugs.debian.org, Sami Liedes <sami.liedes@iki.fi>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 26 Feb 2012 04:37:35 +0000
In-Reply-To: <20120224221101.GA11263@sli.dy.fi>
References: <20120224221101.GA11263@sli.dy.fi>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-XxkelKXn7ifEfNAEWTTc"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XxkelKXn7ifEfNAEWTTc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here's a bug report on perf; I don't think there's anything I can add to
Sami's explanation.

Ben.

On Sat, 2012-02-25 at 00:11 +0200, Sami Liedes wrote:
> Package: linux-tools-3.2
> Version: 3.2.1-2
> Severity: normal
>=20
> Hi!
>=20
> perf report does not show source code lines (annotation) for some
> binaries with separate debug information if those build-id's have been
> cached in perf's build-id cache. This is true for at least those
> packages whose debug symbols are installed in
> /usr/lib/debug/path/binary and not in
> /usr/lib/debug/.build-id/.../$hash. For example, e2fslibs, e2fsprogs
> and I believe very many others packages are affected by this (the
> mentioned packages even after fixing their -dbg packages per #661071).
>=20
> This manifests with the following symptoms. If you want to test this,
> I suggest either waiting for a fix for #661071 to be uploaded or to
> choose a different package from e2fsprogs and its corresponding -dbg
> package (but not one where the -dbg package has files in the .build-id
> directory):
>=20
> ------------------------------------------------------------
> 1. Compile a package with separate debug info (so that you have the
> sources available actually) and install both the package and the -dbg
> package. Use a binary from the package in place of dumpe2fs in
> following steps.
>=20
> 2. Run perf record -g dumpe2fs $some_fs_image
>=20
> 3. Run perf annotate
>=20
> NOTE: functions in e.g. libext2fs.so.2.4 or in dumpe2fs are not
> annotated with source code lines
>=20
> 4. run perf buildid-list. Note that it lists binaries for those
> non-annotated functions. Either find the file in the
> ~/.debug/.build-id directory tree, or investigate using
> perf annotate -vv (grep for "Executing:") where the file file
> resides.
>=20
> 5. Note that the file you found is a copy of the binary or the library
> in question, *not* a copy of the relevant file from /usr/lib/debug.
> The objdump command that perf reports executing does not annotate it
> with source code lines. If you try that same line but replace the
> filename with the path to the actual binary, objdump knows where to
> find the debug info and does annotate it.
>=20
> 6. mv perf.data perf.data.tmp
>=20
> 7. perf record -g ls
>=20
> (this step is important because it empties the build-id cache and
> populates it with objects needed for the ls execution; turns out perf
> handles annotating fine once the relevant object is no longer in the
> build-id cache)
>=20
> 8. perf annotate -i perf.data.tmp
>=20
> NOTE: the functions that were unannotated in step 3 in that old
> perf.data are now correctly annotated with source code.
> ------------------------------------------------------------
>=20
> I think the actual bug is that, for some reason, in step 2 perf record
> copies the non-debug version to the build-id cache instead of the
> debug version. I have not investigated why this happens.
>=20
> I also tried to remove the wrong file from the build-id cache and
> re-add the correct one with perf buildid-cache -v
> --remove=3D1a22c5f5c7a51ede62d01eeba1de59c15e7c9325; perf buildid-cache
> --add=3D/path/to/file, but for some reason I couldn't get that --remove=
=3D
> command to actually remove anything from the cache.
>=20
> 	Sami


--=20
Ben Hutchings
Lowery's Law:
             If it jams, force it. If it breaks, it needed replacing anyway=
.

--=-XxkelKXn7ifEfNAEWTTc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUAT0m3D+e/yOyVhhEJAQqDchAAzswpKp1IeEQPKODLdBjUbLNHa7HT4WyW
T6vzjvT8r6L8Rb1pdiorJMVfv9RKKOdRabvjuSyd3QYA9A1whK4DTPOXQUwnZ1Tu
B3adbepvQBFn/ip5qUllT4vycEurai1PIjoHBQIIjfAvngZ7RyV5PFTPBGCvVJTc
/NuLWBwq/UWngX41vyxd+oRQUe03+O/pvxdFT5BwFqDCWU8lD4XpTlDVMLroNurV
wrq6zUwN7UMFmseuMW4ITdobsdmAvyF89tJtafc+PPYbKup4aGqrtmbbTws7aBSd
UwJ4dEkKtu4wAzrs/xipgxxLo5rfQcF3eoFuHlZVlOpucV/lWo8oJbrY6kOTgJ8Q
8Nq2NmOydg7yH0G6rMMy50/TPCWyxn/b6YiWWF70L+uCEbZlP1/vS6fO0C80C0ay
D4aLayg8fTx6swGCU8ymJR2Acv4XNYQJLK4SJvWcr0ncLVNUKqwUBnJA8fN1aiV3
nauL1nCKBsKdfVBkfEgDBW1mMhpskag8YS24kNRjV4FkN0ZS81/eG3Zmu5caoqWd
78BhXU83J8nPbhbzTw1+kdEsbDNB3nwebvK8M4FTWeE/oqz4PgdO2/zsxKI9omKb
z7pL/fzJe0qcBirdoXHJS6SlR+LUwiMX745EbeGhNzVStAyZZcn9QKAMcRUrR0R2
oOA1kMOjmho=
=Lks6
-----END PGP SIGNATURE-----

--=-XxkelKXn7ifEfNAEWTTc--
