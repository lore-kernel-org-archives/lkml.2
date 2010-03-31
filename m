Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab0CaTyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 15:54:53 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39854 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab0CaTyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 15:54:52 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2] NOMMU: implement vmap/vunmap with kmalloc
Date: Wed, 31 Mar 2010 15:54:36 -0400
User-Agent: KMail/1.13.1 (Linux/2.6.33.1; KDE/4.4.1; x86_64; ; )
Cc: uclinux-dev@uclinux.org, David McCullough <davidm@snapgear.com>,
       Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
References: <1268151081-28307-1-git-send-email-vapier@gentoo.org> <1261413866-30634-1-git-send-email-vapier@gentoo.org> <14998.1270055484@redhat.com>
In-Reply-To: <14998.1270055484@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3013798.Nb9RT8fOQL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201003311554.38473.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3013798.Nb9RT8fOQL
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 31 March 2010 13:11:24 David Howells wrote:
> How about the attached patch instead?  I'd rather not make vmap() general=
ly
> available in NOMMU mode since it can't be implemented in NOMMU mode.  Yes,
> vmap() can take a copy of the pages it is given, but you can't guarantee
> that's the right thing to do.  It's like a shared-writable mmap.
>=20
> Instead, why not just override vmap() in firmware_class.c for the one
> instance where we know we're happy with this behaviour?

how about putting this implementation into like vmap_nommu() and only=20
rewriting vmap() to vmap_nommu() when we know it's safe ?  such as this=20
firmware case ?
=2Dmike

--nextPart3013798.Nb9RT8fOQL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iQIcBAABAgAGBQJLs6h+AAoJEEFjO5/oN/WBh+IQAKtOz718jSi0faTxfwA1IMkK
WHHtTUR+NynDwTgd3Con6IaNBenPVEL3yh+BSnBXjRH77rGoRtDJiPJsRsGEFUAu
0SNtcuC1p9nSLQ4u18JTTCqwdJOvU2jwp7jYUZjaYbTjr2Qwh4y8bTXuLxogIjBW
OibB/JlcWodogAnQfOCTqtsD0n9JfnnU0NU/HTSHfQaT9nCmjrbln7nhs1kOo3qt
+kFBGsMA/tReZHD1z5EWQ/oTWC0dcTfj3s/idYELRyzEZQPw9h3nva256A8Fxfbw
zYt983qE8sc9Cpx4E7Quh5h1uRzK3EX6BcWcShCrtjxrkSIfOZkV2VmUubwAJMsw
He8LfiaFYS+4RM+uQ+/J/LtVK4M5jQeGQqS3OAA1HDS+PRH9flpgWEWvM7/KgN0S
E6XmQdUMdBOInBZ+mP/D4VtIwrVhM2MnnPARpRkZcQ6e8cX88GIZLa1rWzKcnSFG
YuIO65RL4Xl8tOnrpQFF/+ro/FWMW0rwQ7P2F/6Alvh1OZeBlWsJII8ggvsMiAwp
jiAlrw3Kz/S9imYNlPYfj5O+8hIW7aLcaENaR8X43WLaDpBsdeQEI0ncK4zBlIKy
AqZZP65GX9w9WQQYbnazYie3UYQREpgkyFvqsf4cIU+lWnHezjRje/0gT2iGPlt9
OM7keTlNno4cFTdo46Ni
=nzvW
-----END PGP SIGNATURE-----

--nextPart3013798.Nb9RT8fOQL--
