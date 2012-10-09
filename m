Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab2JIAdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 20:33:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49100 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754427Ab2JIAdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 20:33:20 -0400
Message-ID: <1349742791.6336.11.camel@deadeye.wl.decadent.org.uk>
Subject: Re: mpol_to_str revisited.
From: Ben Hutchings <ben@decadent.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 09 Oct 2012 01:33:11 +0100
In-Reply-To: <20121008150949.GA15130@redhat.com>
References: <20121008150949.GA15130@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Y9MwhCVWrtXjuOnyH+rX"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Y9MwhCVWrtXjuOnyH+rX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-10-08 at 11:09 -0400, Dave Jones wrote:
> Last month I sent in 80de7c3138ee9fd86a98696fd2cf7ad89b995d0a to remove
> a user triggerable BUG in mempolicy.
>=20
> Ben Hutchings pointed out to me that my change introduced a potential lea=
k
> of stack contents to userspace, because none of the callers check the ret=
urn value.
>=20
> This patch adds the missing return checking, and also clears the buffer b=
eforehand.
>
> Reported-by: Ben Hutchings <bhutchings@solarflare.com>

I was wearing my other hat at the time (ben@decadent.org.uk).

> Cc: stable@kernel.org
> Signed-off-by: Dave Jones <davej@redhat.com>
>=20
> ---=20
> unanswered question: why are the buffer sizes here different ? which is c=
orrect?
[...]

Further question: why even use an intermediate buffer on the stack?
Both callers want to write the result to a seq_file.  Should mpol_str()
then be replaced with a seq_mpol()?

Ben.

--=20
Ben Hutchings
Who are all these weirdos? - David Bowie, about L-Space IRC channel #afp

--=-Y9MwhCVWrtXjuOnyH+rX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHNwx+e/yOyVhhEJAQrlihAAjp47UOZEb3F0sVUQOByVmd1WUR3+fTLB
BOMP/WZnKdRACzz3GCNisWsCUyUnBXGTdxsjNjkcFOYxBMe/d2CyZIlUMxJiLVv0
E0OtpNqvXcOiPNiF60rN7+9/eQc21ME2G6EBVjgQi0/9tcLsVFhucY8Iar6Go/9x
GY8I+6yeBQ32/afOTrnEma5BQbf5M5kPCQHGKlo0PX237Eu1WpYafDahQl4RYVSd
utaZC7xLiBtqQFLV56QKWQlU4T5CSoGVVcX6F/ZMpSrwJ4d6SZhB0d+5vO6APnfh
6rPWuQNxICjdiXjCTew2i6nNRYKf5l8t+aYw0+c62Wf2GUKRLd2ZaGDIsAOeHpT9
s+W4BGa2CGJx5VcCT81zFMi2dWyaRPQ7zg2DMTC+J+CS+Vk+dSnS/nWm2iU7XtTm
hoPuVx1W4weVN8txhtVqeh2QR0eglwTrWWQSKr4CMl1u3h+2uXFewZA2Ke8JQk6T
9rinjAgsLxj5nSeUSYLJLy4drMdR2C+Q0q+pgPdHCraF+uxd9OnFF9DuSs+X7i8s
norB41sqHbQfD35nK+J5F68nqYSKi7I4E5ORHWnfvKpDSmT9g4zASBpXJ6iLvzcA
NwhidylqfVjUDcqho8WpMhn3KxQok+k9JPQQoDFX8CgLUtQD8J5wE/TLzZwsxXt2
xc5CfDLmjSs=
=+VgZ
-----END PGP SIGNATURE-----

--=-Y9MwhCVWrtXjuOnyH+rX--
