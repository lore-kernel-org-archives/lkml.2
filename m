Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab2EVDET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 23:04:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46409 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589Ab2EVDEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 23:04:00 -0400
Date: Tue, 22 May 2012 13:03:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Rientjes <rientjes@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: PowerPC boot failures in next-20120521
Message-Id: <20120522130354.fdb335eb294f4206b4b2fed5@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.00.1205211846120.20916@chino.kir.corp.google.com>
References: <20120522114051.0c9db9a7c2d660bc9e0e1be2@canb.auug.org.au>
	<alpine.DEB.2.00.1205211846120.20916@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_13_03_54_+1000_haxAE.AciyWA7TxE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_13_03_54_+1000_haxAE.AciyWA7TxE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Mon, 21 May 2012 18:53:37 -0700 (PDT) David Rientjes <rientjes@google.co=
m> wrote:
>
> Yeah, it's sched/numa since that's what introduced numa_init().  It does=
=20
> for_each_node() for each node and does a kmalloc_node() even though that=
=20
> node may not be online.  Slub ends up passing this node to the page=20
> allocator through alloc_pages_exact_node().  CONFIG_DEBUG_VM would have=20
> caught this and your config confirms its not enabled.
>=20
> sched/numa either needs a memory hotplug notifier or it needs to pass=20
> NUMA_NO_NODE for nodes that aren't online.  Until we get the former, the=
=20
> following should fix it.
>=20
>=20
> sched, numa: Allocate node_queue on any node for offline nodes
>=20
> struct node_queue must be allocated with NUMA_NO_NODE for nodes that are=
=20
> not (yet) online, otherwise the page allocator has a bad zonelist.
>=20
> Signed-off-by: David Rientjes <rientjes@google.com>

Thanks, that fixes it.

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_May_2012_13_03_54_+1000_haxAE.AciyWA7TxE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuwIaAAoJEECxmPOUX5FEoj8P/izwzpFzKBIxDEt4t+Nx8b5a
KEHdgnB0XA7jd6W5O5cr+QikpYBqoZso1iSzO72bLcDgG3hSiX2yuXexFNCerVfI
nKFZtsbyZ2G5NhZKaQFdglMtTpAraUBVoJevEF3bB/miijBgK4cnDgwVpX0mKlFd
QL3SBgEoUVBF7Qdy8HQD204fqO015ykQyTn6flsWA/S7eVEQ07eOhsFCY5NhwDHb
V8h++WCvdrdSd/HyiIlgJMM3SOIjcd0SrbklIaR0wk2mAXyj7Tvz96WOwad4WR4Z
SMt3DityCY6oS/QR1Bd5zcNTDz8FKd8adPM8JyyGSx9AwLu6tSAf8toEadncRLTp
LdMm+aoysJCX9fEJNwC9n8w14ubTSyvP0135MZythF3RW27yKuOgaJ5P3BgGhn/I
8ZpukpHLfMlWWT2jrSCJt63fjyCi4++SSFk7lZPHZTvgNns/LQjBeVkwZH3IJUux
NXzqpGFlgrjpiS/mYRZyL6tY9Z71cI141PUPPfPUwBLi8F2So9dAHRM6krsKjvY4
9FMzW+ax5Slnt1Q/7+ajcODC+UFfYDAtanwszAdKYfTRQxTIj9Gnmx8WhdBkFdz9
UtKsxXe5yyo2t4s/kyPX3aOIRmzZYp6xgcRpkLblcXf6mNVd2vGj/ozR7KNTSH/2
JinIuO9RyoOq4VwvtALM
=BcqL
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_13_03_54_+1000_haxAE.AciyWA7TxE--
