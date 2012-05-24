Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2EXISW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:18:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:26745 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab2EXISU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:18:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="147177216"
Message-ID: <1337847720.15137.85.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com, tglx@linutronix.de
Date: Thu, 24 May 2012 11:22:00 +0300
In-Reply-To: <4FBBC4EE.4040802@nod.at>
References: <1337608916-49771-1-git-send-email-richard@nod.at>
	 <1337608916-49771-2-git-send-email-richard@nod.at>
	 <20120522180119.2c2a10a8@pixies.home.jungo.com> <4FBBC4EE.4040802@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ANTLuREx6GKnyESMJys2"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ANTLuREx6GKnyESMJys2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-22 at 18:55 +0200, Richard Weinberger wrote:
> >> +     * has never seen any PEB used by the original fastmap.
> >> +     */
> >> +    if (!e) {
> >> +            ubi_assert(ubi->old_fm);
> >> +            e =3D kmem_cache_alloc(ubi_wl_entry_slab, GFP_ATOMIC);
> >
> > Must it be GFP_ATOMIC?
>=20
> Yes. This function is called under a spinlock.

I did not look close, but this sounds bad.

You need to have a much better justification than "I allocate it under a
spinlock". You need to tell "... because there is no way or very
difficult to pre-allocate it while I do not have the spinlock held,
because ... (explanation)".

>=20
--=20
Best Regards,
Artem Bityutskiy

--=-ANTLuREx6GKnyESMJys2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPve+oAAoJECmIfjd9wqK0V9AP/33Gw2N7AeNDrQ1bl+FqgfoK
dnLNrKk6vwphWWs+Ke/xM0t3sIbcMBJhzEyD0mlqJFE0ZYm9rKwRu2HMXocZ3QX0
UNTRCD1E1peScgcUmZINu2vF5R9PNY0yQrD30UNHR8en198bsUWl+Vb+1zFjI9Yj
8+ilIb3OYPPgXuPCCxDEsquDWSSIYwIjcBEH0d3tRxLA1/qIZFejWBb92oGA0T/W
zrU19iV5sctfWMUhXZFK62dvD+8ZbjXbeKbXHE/FwJgsYejyKAstn69v2m/Pdean
A61YlI7rg9jwt6U8ML2E4LOFqhKpt13xzOIoho4lK6rAaT8twrAo/mI6BwqMcrWF
ujP1hK3lMgjhFBpTD3elQ/eNPMXuEeRlEWcskHPDKyWubfnNNtlO0Cqy8q3roxt8
L6xGyeWYalKmi98YABcuHN2YKSlngZ1Kh1NucTp+7s8j3RPmWgJ53PySc8ZdTny8
PJLdyAl6pM6pVzK6RaDgypWFJMQk4WGuOKr89bGCwnOXnCaRMN1mV42jaMwn/LQI
0WvUpTbwppFdDwmoMQRedtwtCngwu4ZLf8gzLhHtQJgpJyQ30QYX5JM5fnkk0f7O
ikK2WJBCHKoTuAbftC87OPA2CuADfKkxDSiKLWxFAIDnI0sCHze8LCUGELy5IXE4
d9nXe+8zg8ZyvYKN3SWe
=4H+H
-----END PGP SIGNATURE-----

--=-ANTLuREx6GKnyESMJys2--

