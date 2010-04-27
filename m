Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab0D0Hcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 03:32:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41255 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab0D0Hcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 03:32:35 -0400
Date: Tue, 27 Apr 2010 17:32:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] lockdep: Fix redundant_hardirqs_on incremented with
 irqs enabled
Message-Id: <20100427173227.7ec29329.sfr@canb.auug.org.au>
In-Reply-To: <1271338670-4537-1-git-send-regression-fweisbec@gmail.com>
References: <20100415200414.1ef705c8.sfr@canb.auug.org.au>
	<1271338670-4537-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Apr_2010_17_32_27_+1000_WnypVAOULDdjE+Yg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Apr_2010_17_32_27_+1000_WnypVAOULDdjE+Yg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Frederic,

On Thu, 15 Apr 2010 15:37:50 +0200 Frederic Weisbecker <fweisbec@gmail.com>=
 wrote:
>
> When a path restore the flags while irqs are already enabled, we
> update the per cpu var redundant_hardirqs_on in a racy fashion
> and debug_atomic_inc() warns about this situation.
>=20
> In this particular case, we need to explictly disable the irqs before
> updating this stat var in order to update it safely.
>=20
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: David Miller <davem@davemloft.net>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  kernel/lockdep.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)

Ping?  Any movement on this?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Apr_2010_17_32_27_+1000_WnypVAOULDdjE+Yg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWkwsACgkQjjKRsyhoI8xLngCdGSGiaLRVeLhm3giq+01yrZeP
5d0An1rPSG2eovKYd0Jg9PxBOZTMp2Ll
=Q59b
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Apr_2010_17_32_27_+1000_WnypVAOULDdjE+Yg--
