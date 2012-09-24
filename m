Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab2IXX6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 19:58:31 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45025 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab2IXX6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 19:58:30 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 22/30] perf tools: bfd.h/libbfd detection fails with recent binutils
Date: Mon, 24 Sep 2012 19:58:30 -0400
User-Agent: KMail/1.13.7 (Linux/3.5.2; KDE/4.6.5; x86_64; ; )
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
References: <1348502384-14442-1-git-send-email-acme@infradead.org> <1348502384-14442-23-git-send-email-acme@infradead.org>
In-Reply-To: <1348502384-14442-23-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1890150.uHzCySCp9i";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201209241958.33449.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1890150.uHzCySCp9i
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 24 September 2012 11:59:36 Arnaldo Carvalho de Melo wrote:
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
>
> -		FLAGS_BFD=3D$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd
> +		FLAGS_BFD=3D$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE=3D'perf'=
 -

in this case, if you were to expand PACKAGE, you'd get back the symbol perf=
=20
(which most likely will be an error, but maybe it won't).  i think this sho=
uld=20
be instead:
	-DPACKAGE=3D'"perf"'

> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
>
> +#define PACKAGE 'perf'

this isn't valid C anywhere.  pretty sure this should be:
	#define PACKAGE "perf"
=2Dmike

--nextPart1890150.uHzCySCp9i
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQYPOpAAoJEEFjO5/oN/WBMewP/35UqJ7XWQRIHea+eSAzSIEp
WT8Wyab2ZHLEIyNqz0t0gWoqpOhAkrvWQ+1yrhkL5xmq/bdZJsKcouDhy0GWBgEk
s3ekvQcwuOmDUKnKmsqJeheI9WRUq7MfXq4I9bXk4GfWBxoIhnv2Ra/NhjgVHHzi
wycHP8u3cvr+K1tg9Q1lc4o2NxaHaTnDo9AXQafzoRx6G5ulJMfOGWr44UN7vu+8
DgMEd5IG8YnZsR6RDcP+CqXXmHxMslvDpYDlQnZ88EoqeTwzo3hOEsmV9tRroZBr
cUFelsPu1vDisZUekILtzKBOM/+lX0fF5CxnnjcDbmMp1rRY1L9IPjA0QfwUSNwW
DTKwiP2ULfqNpYE/YiFIBaaVu4LSKFfxnfbo0dnnGJzvfyexM+wc50Zsl27bvDMz
HHSY2cEAMALxa6jtu/VIFWbE8yLzTZIPrujg09Mj3jPpd0KPgLRrpcqUwWdyIeFs
xVaRgo3Y9fyUQ457D3RyDBuIwjDAwgeCzSgdydib6iUK/MvEaWya9fLEJ03Ji+4g
5+HmqULByYX7oSvlVk4zvq8bGM/XwTMlWIpeVCD+eE31gBpiisU6HnM0SGrPpak5
EtR9SbaZTDbLRvdwiLrC+lwrqrd/SUWteji7SjprmH63qnnnnImGWTJJkhKlap+N
S/LymiiVJGGkZNcfQllG
=WAdb
-----END PGP SIGNATURE-----

--nextPart1890150.uHzCySCp9i--
