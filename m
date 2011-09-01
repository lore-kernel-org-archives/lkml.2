Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab1IALOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 07:14:43 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:42773
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944Ab1IALOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 07:14:38 -0400
Message-ID: <4E5F690C.4010209@akkadia.org>
Date: Thu, 01 Sep 2011 07:14:20 -0400
From: Ulrich Drepper <drepper@akkadia.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Jeremy Allison <jra@samba.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Ehrenberg <dehrenberg@google.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: Approaches to making io_submit not block
References: <x49k49uk2ox.fsf@segfault.boston.devel.redhat.com> <4E5D5817.6040704@kernel.dk> <CAAK6Zt2C1646qwDiZ7sWheSWrnx2yrDtCE=+VTx7QNyh2bEz_g@mail.gmail.com> <4E5D64E8.7000102@kernel.dk> <20110830154157.d802d097.akpm@linux-foundation.org> <CAAK6Zt20MNqgydQTgN3O46p+OZxR9Ta9=MfqRrw=w+y77-75Yw@mail.gmail.com> <20110830155438.bc31ab99.akpm@linux-foundation.org> <20110830230342.GB16326@samba2> <20110830161130.592df746.akpm@linux-foundation.org> <4E5E152A.9050804@akkadia.org> <20110831165954.GC1611@samba2>
In-Reply-To: <20110831165954.GC1611@samba2>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF21377A55752E9EF5A0A63F2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF21377A55752E9EF5A0A63F2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08/31/2011 12:59 PM, Jeremy Allison wrote:
> I get that, but isn't that what the aio_init(const struct aioinit *init=
) call is meant to
> solve ?

The problem cannot be solved by something that trivial.  Any thread can
be delayed indefinitely.  If this happens for a file descriptor chances
are that all threads for the same file descriptor are affected while
there is I/O for all the other file descriptors ready to run.  I don't
say this is anywhere near optimal or even good, at least it doesn't
amplify problems.  If you know you want more parallelism on the same
file descriptor, dup it.  If you don't want anyone like me implementing
stupid limitations finally fix the kernel aio interface so that it is
usable.


--------------enigF21377A55752E9EF5A0A63F2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk5faQwACgkQ2ijCOnn/RHTw3gCfTyA2FJslheyN+jYGbglMuf3D
dXEAoLAd0c+zD3sI9YAkY8UcWxgOVYwN
=Kkp1
-----END PGP SIGNATURE-----

--------------enigF21377A55752E9EF5A0A63F2--
