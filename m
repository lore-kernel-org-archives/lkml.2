Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab2J2Q67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:58:59 -0400
Received: from mail4.gandi.net ([217.70.183.210]:60350 "EHLO mail4.gandi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759406Ab2J2Q65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:58:57 -0400
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2012 12:58:57 EDT
Date: Mon, 29 Oct 2012 17:51:41 +0100
From: William Dauchy <william@gandi.net>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Asias He <asias.hejun@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm tools: fix rbtree-interval search
Message-ID: <20121029165141.GG1109@gandi.net>
References: <1351512780-8563-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="udcq9yAoWb9A4FsZ"
Content-Disposition: inline
In-Reply-To: <1351512780-8563-1-git-send-email-kirill.shutemov@linux.intel.com>
Reply_to: William Dauchy <william@gandi.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--udcq9yAoWb9A4FsZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Oct29 14:12, Kirill A. Shutemov wrote:
> I've noticed message on kvm exit:
>=20
>   Warning: serial8250__exit failed.
>=20
> kvm tool is not able to remove ioport range which was added previously.
>=20
> The issue is caused by bug in rbtree-interval. Search algorithm in
> rb_int_search_single() expects correct value of max_high. But the tree
> can contain leaf nodes, which never were updated by propagate_callback().
> For this kind of nodes high_max will be 0 and we will not be able to
> find and remove them.
>=20
> Let's initialize max_high on RB_INT_INIT() time.
>=20
> Fixing this bug makes other bug visible: propagate_callback() can be
> called for empty tree: node =3D=3D NULL. The callback is not ready for em=
pty
> tree. Let's fix that as well.
>=20
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

I had the same issue but didn't found the time to fix it.
Applying the patch fixes the problem.

Tested-by: William Dauchy <william@gandi.net>

Thanks,
--=20
William

--udcq9yAoWb9A4FsZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCOtB0ACgkQ1I6eqOUidQHQ6QCffer5opfnTyL3YQ/cW0g6xEPe
8IAAnjZqljQq726dLSlQRSosthBcPE1E
=6gak
-----END PGP SIGNATURE-----

--udcq9yAoWb9A4FsZ--
