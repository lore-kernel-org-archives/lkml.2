Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab1HaLFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 07:05:35 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:36724
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754787Ab1HaLFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 07:05:31 -0400
Message-ID: <4E5E152A.9050804@akkadia.org>
Date: Wed, 31 Aug 2011 07:04:10 -0400
From: Ulrich Drepper <drepper@akkadia.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeremy Allison <jra@samba.org>, Daniel Ehrenberg <dehrenberg@google.com>,
        Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org
Subject: Re: Approaches to making io_submit not block
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>	<CAAK6Zt0Sh1GdEOb-tNf2FGXJs=e1Jbcqew13R_GdTqrv6vW97w@mail.gmail.com>	<x49k49uk2ox.fsf@segfault.boston.devel.redhat.com>	<4E5D5817.6040704@kernel.dk>	<CAAK6Zt2C1646qwDiZ7sWheSWrnx2yrDtCE=+VTx7QNyh2bEz_g@mail.gmail.com>	<4E5D64E8.7000102@kernel.dk>	<20110830154157.d802d097.akpm@linux-foundation.org>	<CAAK6Zt20MNqgydQTgN3O46p+OZxR9Ta9=MfqRrw=w+y77-75Yw@mail.gmail.com>	<20110830155438.bc31ab99.akpm@linux-foundation.org>	<20110830230342.GB16326@samba2> <20110830161130.592df746.akpm@linux-foundation.org>
In-Reply-To: <20110830161130.592df746.akpm@linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF18CB5BF271D70C8C34D945B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF18CB5BF271D70C8C34D945B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08/30/2011 07:11 PM, Andrew Morton wrote:
> I don't know.  Uli cc'ed.

glibc has to create the parallelism of the operations through threads.
More threads mean more overhead.  There are insane people out there who
wrote code which pushed the number of helper threads into the hundreds
(at that time a high number, today this would be in the thousands).
Anyway, any scheme which is worth changing the code for would be in the
kernel.  Only the kernel knows which requests can actually be handled
concurrently.


--------------enigF18CB5BF271D70C8C34D945B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk5eFSoACgkQ2ijCOnn/RHSPYACfVO1UwifSPGbzkVN2XW/WonFA
FU4AoMuf9HHPXIAEGN0CzPQqB6y5vGLk
=eJ+H
-----END PGP SIGNATURE-----

--------------enigF18CB5BF271D70C8C34D945B--
