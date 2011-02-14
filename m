Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab1BNXOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:14:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40545 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435Ab1BNXOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:14:37 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        Slava Pestov <slavapestov@google.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20110206232253.378726212@pcw.home.local>
References: <20110206232253.378726212@pcw.home.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-z6e9rcrCiGOKEZxWCbTC"
Date: Mon, 14 Feb 2011 23:14:27 +0000
Message-ID: <1297725267.3104.84.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [PATCH 20/23] tracing: Fix panic when lseek()
 called on "trace" opened for writing
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-z6e9rcrCiGOKEZxWCbTC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-02-07 at 00:23 +0100, Willy Tarreau wrote:
> 2.6.27.58-stable review patch.  If anyone has any objections, please let =
us know.
>=20
> ------------------
>=20
> From: Slava Pestov <slavapestov@google.com>
>=20
> commit 364829b1263b44aa60383824e4c1289d83d78ca7 upstream.
>=20
> The file_ops struct for the "trace" special file defined llseek as seq_ls=
eek().
> However, if the file was opened for writing only, seq_open() was not call=
ed,
> and the seek would dereference a null pointer, file->private_data.
>=20
> This patch introduces a new wrapper for seq_lseek() which checks if the f=
ile
> descriptor is opened for reading first. If not, it does nothing.
[...]
> --- longterm-2.6.27.orig/kernel/trace/trace.c	2011-01-23 10:52:37.0000000=
00 +0100
> +++ longterm-2.6.27/kernel/trace/trace.c	2011-01-29 11:42:07.287067215 +0=
100
> @@ -2041,17 +2041,25 @@
>  	return ret;
>  }
> =20
> +static loff_t tracing_seek(struct file *file, loff_t offset, int origin)
[...]
> +	.llseek		=3D tracing_lseek,
[...]
> +	.llseek		=3D tracing_lseek,
[...]

These names don't agree!

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-z6e9rcrCiGOKEZxWCbTC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATVm3UOe/yOyVhhEJAQLzExAAgy/iBRPE2Nyo8HPko19QDW5s5nRnyykL
DPYzBHYkn8bUpbul3zYmjWiqh/Mgvg/KRe4hAG9jTGoXM/I4pX7iq/145wQt0i0i
RhAA5NDC1wfiIuD/iG3AGJ+N4edEloq3WeRQG2K+u97eUowc9iKMuhKPRgrIKy0r
lWCCvpG2hBF8nVoaDyrIPM/xdlxg4TqJ4+3G0QJtEP15kv8+1LeFo5RURhyQ31FD
KKoEjJ/2ba+qHsDNQMVaU2HQSdmQAoVUG4FZwQ7bn6s0fchnWUMU7R1Q5SQDoOvE
HBEY6Kv2+uBxWygqeHVfxC8MdUY7+7ly/AWIID5cdRyYNc+ENe27SjSQi0RnDoq+
qgR7nPrUfayshKjhVTl1+TIcyyvQxqD0zrjGjKpI7Zcnr0apY90DszE/KkonoeaQ
e8Ez2x3eNTTi9lreq+Y2F/eA3NXS8NKussOhkxtlReu5hwXfgOPiOt6lt7HC3YeN
JzdAebk37QN9M51Zgl7LLKjWdntCMWOn46oAnS/MRVEJHpoDY/bX2XoDFLCJ5Vb5
PPwOI/LOr/5IyQKd8tNLUkJfWFvYZ2kNnq1xAwsI0zF+WGu8Y8tdykDGN2jHDxhV
Hcab/QPT1EKfQ8SxhBTieHZaUECS0UBMwg5hVHKKOsTdnawmppe66nd0UjBlo0dU
mXOrBPv6aXc=
=bP5y
-----END PGP SIGNATURE-----

--=-z6e9rcrCiGOKEZxWCbTC--
