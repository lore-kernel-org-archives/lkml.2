Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab1DHHRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 03:17:05 -0400
Received: from ozlabs.org ([203.10.76.45]:43747 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab1DHHRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 03:17:04 -0400
Subject: Re: [PATCH] mm: Check we have the right vma in access_process_vm()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Michel Lespinasse <walken@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        aarcange@redhat.com, riel@redhat.com, Andrew Morton <akpm@osdl.org>,
        linuxppc-dev@ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <BANLkTi=RJ2GHvHQ3mZiQ-L-MTVUQH-V-eA@mail.gmail.com>
References: <c4f5166f98cb703742191eb74f583bb8011f9cdf.1301984663.git.michael@ellerman.id.au>
	 <BANLkTi=RJ2GHvHQ3mZiQ-L-MTVUQH-V-eA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nLXr8uPyUESvFTc0bAW4"
Date: Fri, 08 Apr 2011 17:17:03 +1000
Message-ID: <1302247023.5744.44.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nLXr8uPyUESvFTc0bAW4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-04-04 at 23:42 -0700, Michel Lespinasse wrote:
> On Mon, Apr 4, 2011 at 11:24 PM, Michael Ellerman
> <michael@ellerman.id.au> wrote:
> > In access_process_vm() we need to check that we have found the right
> > vma, not the following vma, before we try to access it. Otherwise
> > we might call the vma's access routine with an address which does
> > not fall inside the vma.
> >
> > Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
>=20
> Please note that the code has moved into __access_remote_vm() in
> current linus tree.

Ah good point, if git hadn't done such a good job of merging it I would
have noticed :)

I'll send a new version with a corrected changelog.

> Also, should len be truncated before calling vma->vm_ops->access() so
> that we can guarantee it won't overflow past the end of the vma ?

The access implementations I've looked at check len, but I guess it
could be truncated on the way in. But maybe that's being paranoid, I
dunno.

cheers


--=-nLXr8uPyUESvFTc0bAW4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk2etmoACgkQdSjSd0sB4dKa0gCguGfnLjk1m+jsQBXWGJWeIegS
tYAAoI4Pp5TyVwDtf/QAbqtYI8HwWzsd
=wPcR
-----END PGP SIGNATURE-----

--=-nLXr8uPyUESvFTc0bAW4--

