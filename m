Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2E2KVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:21:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:29129 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab2E2KVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:21:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="149667333"
Message-ID: <1338287087.2536.7.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] netwinder: nw_gpio_lock is a raw_spinlock_t
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Woodhouse <dwmw2@infradead.org>
Cc: Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, alsa-devel@alsa-project.org,
        vamos-dev@lists.cs.fau.de
Date: Tue, 29 May 2012 13:24:47 +0300
In-Reply-To: <1338286268.11518.157.camel@shinybook.infradead.org>
References: <1338040464.2525.38.camel@koala>
	 <20120525082812.GA12238@faui49q.informatik.uni-erlangen.de>
	 <20120529100619.GA23186@faui49q.informatik.uni-erlangen.de>
	 <1338286268.11518.157.camel@shinybook.infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-IxEtVhnfOtZkHtxtI0cF"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IxEtVhnfOtZkHtxtI0cF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-29 at 11:11 +0100, David Woodhouse wrote:
> On Tue, 2012-05-29 at 12:06 +0200, Christian Dietrich wrote:
> > Since nw_gpio_lock is a raw_spinlock_t it should be used with the
> > raw_spinlock_* functions and not the spinlock_* variants. Functionally
> > this is equivalent at the moment, because the raw_spinlock_t is the
> > first field of spinlock_t, and therefore &nw_gpio_lock =3D=3D
> > &(nw_gpio_lock->rlock). But when other spinlock_t functions use other
> > field they read and write random memory.
>=20
> Hm, why are we exposing a raw spinlock to drivers?=20
>=20
> Should we export a helper function (or macro, I suppose) which does the
> appropriate locking *and* the GPIO operation?

AFAIR, raw spinlock is the one that will not be turned into a
"preemptable" spinlock in the RT tree. E.g., this is needed when dealing
with interrupts. And what if not drivers should use them?

But this commit message did not explain still (although I requested)
_why_ it needs a raw spinlock, which problems it solves?

This URL may be useful for Christian:

http://who-t.blogspot.com/2009/12/on-commit-messages.html

I like that blog-post.

--=20
Best Regards,
Artem Bityutskiy

--=-IxEtVhnfOtZkHtxtI0cF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPxKPvAAoJECmIfjd9wqK0/G8P/1bj7yQW03M16O3VloXydNIf
aFhsQJ70UTZh9tDoDpNwut7cDkYSrjt72T8BtBhT5TRMcepeR3mLY+oxhDEoRiJ9
WS299NZAz7MoqMTiECHYzF7s2Bf0NbwKUxVmcNdr1hIszTk3+kXHdGv4iPVkyZCx
OcZ55eUYagMkh3E1+iViNJotIUYAV7MUHyrhBxxpxfStQg6fJ0R6Rl1MiM3dqWHX
TJOt4J1e1jjQbWK3F2Q9l/YgTpHKeyC316zWrEDi3nfcmGgBR8PEpQBREAY/baUb
DzdfbWVbtarPovIuhFzvmDbffbgRhPW/1KtD2B/+X1z8DAJuYAkZHQXQXvGvtSY3
vOaPoPXk6bl9NbRO0O5oiRk8RCYSAs/LPWg2rdTNpySmKPX/yyXxzCWA3Euv5QQn
1bLBb7KzgcmIasCvHianC+aJx7P0IWx5BE0t0anAJa1JLzc4P0dTZ9Kqd1ePau6i
fNr1TSpe3EPgaAsTiDP6AeT8CeKI9HOSy+wVuV9ILg6gld4Ou++x970taCwLLmKt
hBzYdG9kMQZmfqPZ6DmwKSaOrU6Wu/OA46Dfzm3OTm3zZdL1JkLOIwrtF1OCLcv+
5UeoK4gQ7dc7XIgkM6wShxnZPMdxYe3iW5ahbztrDnGS1DImZ8065TqOguafnmdv
qNLk0pxAL55y2ATggJay
=LVla
-----END PGP SIGNATURE-----

--=-IxEtVhnfOtZkHtxtI0cF--

