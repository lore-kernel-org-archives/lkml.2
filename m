Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab2EVDZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 23:25:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35951 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab2EVDZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 23:25:15 -0400
Date: Tue, 22 May 2012 13:25:10 +1000
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
Message-Id: <20120522132510.761887493037293b0ef2b2af@canb.auug.org.au>
In-Reply-To: <20120522130354.fdb335eb294f4206b4b2fed5@canb.auug.org.au>
References: <20120522114051.0c9db9a7c2d660bc9e0e1be2@canb.auug.org.au>
	<alpine.DEB.2.00.1205211846120.20916@chino.kir.corp.google.com>
	<20120522130354.fdb335eb294f4206b4b2fed5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_13_25_10_+1000_CMWx5LxEcYuZa1s7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_13_25_10_+1000_CMWx5LxEcYuZa1s7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 22 May 2012 13:03:54 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 21 May 2012 18:53:37 -0700 (PDT) David Rientjes <rientjes@google.=
com> wrote:
> >
> > Yeah, it's sched/numa since that's what introduced numa_init().  It doe=
s=20
> > for_each_node() for each node and does a kmalloc_node() even though tha=
t=20
> > node may not be online.  Slub ends up passing this node to the page=20
> > allocator through alloc_pages_exact_node().  CONFIG_DEBUG_VM would have=
=20
> > caught this and your config confirms its not enabled.
> >=20
> > sched/numa either needs a memory hotplug notifier or it needs to pass=20
> > NUMA_NO_NODE for nodes that aren't online.  Until we get the former, th=
e=20
> > following should fix it.
> >=20
> >=20
> > sched, numa: Allocate node_queue on any node for offline nodes
> >=20
> > struct node_queue must be allocated with NUMA_NO_NODE for nodes that ar=
e=20
> > not (yet) online, otherwise the page allocator has a bad zonelist.
> >=20
> > Signed-off-by: David Rientjes <rientjes@google.com>
>=20
> Thanks, that fixes it.
>=20
> Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

And I will put that patch in linux-next until it (or something better)
appears.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_May_2012_13_25_10_+1000_CMWx5LxEcYuZa1s7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuwcWAAoJEECxmPOUX5FEmW8QAIcB6zJRrUaLwfOuiBESxh8z
0CwQoMS/X43obsQV7jTDRjNkMIlsnpNIxs4f1ADx227KJkgO4jvsUT5l3LCWFx0P
ySvWCJyZc6JgS/6mIVD6C9o483Ib4vfIPCXBP8ce3RAe7G6GAUVkTpH6LkE4G5eR
jZzhK9Z278OC2JETzM/dTofGW0ckv9rAGCrysFqrA7IpiGG/H9jmVPNvvkk9O0Zl
F1jGVG+lGbjIs7tmy4ve4FTo9L2VUwDyTjFI28CnBsUN+zNWEggx8JQDn3r1iwBD
trEH83Vx8ZIl9q+xMdG3XtWUU1cB588zFW414y3K8vD7evTm24c8CHMiFj76ZxIx
vCEJpuFFrawqCzOtidlYgUfzRZHwj27YXmfgrDIr5EcC76A8tGol+v7EPc9JttNs
RTFmQI1p7PN5bsQrecS+ElzUg+XQuzm+12PPVoY7yhHpKw/+J2CNy9aaEdO1afxR
MhK04Un2LY+WiAbeknJ/lNdV5mUH4oiUP2Ag5R6xFPtVz3b/o45+q+tnUqBF427Q
1IMCaWadXFbniLsCeCgUXJxlY4eBtpBjEEHf9jlOp0GuB94k1EcgyGsjsHMpTnR+
CEJ3sE3Tbub5cbQi0pUM+n/dGdaays8DwsjjpcJ4yk5F0vpRK/68RpWepX8A4Lwr
PhhuH+SdyUW3EUqa00IL
=Kue6
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_13_25_10_+1000_CMWx5LxEcYuZa1s7--
