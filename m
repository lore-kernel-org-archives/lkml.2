Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab2ESNgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 09:36:19 -0400
Received: from manchmal.in-ulm.de ([217.10.9.201]:35215 "EHLO
	manchmal.in-ulm.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab2ESNgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 09:36:18 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 May 2012 09:36:17 EDT
Date: Sat, 19 May 2012 15:27:33 +0200
From: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sami Liedes <sami.liedes@iki.fi>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [ 31/54] kmemleak: Fix the kmemleak tracking of the percpu
 areas with !SMP
Message-ID: <1337433313@msgid.manchmal.in-ulm.de>
References: <20120518212656.GA4992@kroah.com>
 <20120518211602.287791770@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20120518211602.287791770@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Greg KH wrote...

> 3.0-stable review patch.  If anyone has any objections, please let me kno=
w.

> From: Catalin Marinas <catalin.marinas@arm.com>
>=20
> commit 100d13c3b5b9410f604b86f5e0a34da64b8cf659 upstream.

> +	/* kmemleak tracks the percpu allocations separately */
> +	kmemleak_free(fc);

That one causes:

    mm/percpu.c: In function =E2=80=98setup_per_cpu_areas=E2=80=99:
    mm/percpu.c:1877: error: implicit declaration of function =E2=80=98kmem=
leak_free=E2=80=99
    make[1]: *** [mm/percpu.o] Error 1
    make: *** [mm] Error 2

Trivial fix, works for me: Add

    #include <linux/kmemleak.h>

to mm/percpu.c. FWIW, upstream did this in in f528f0b but I cannot
tell whether that commit is in any way of interest for 3.0.x.

Regards,

    Christoph

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk+3n8UACgkQBq/69tVAGy3wygCffp9VrxCxtNzqzQV/JOFvGBuT
eq0AnRcPoFGs3u8xHQXZ/m0xUgIjyZPD
=yTqG
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
