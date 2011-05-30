Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab1E3WTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 18:19:12 -0400
Received: from smp.if.uj.edu.pl ([149.156.82.206]:45542 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880Ab1E3WTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 18:19:11 -0400
From: "Witold Baryluk" <baryluk@smp.if.uj.edu.pl>
Date: Tue, 31 May 2011 00:19:08 +0200
To: Andrew Lutomirski <luto@mit.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Kernel OOPS in function_graph_tracer due to the
 44259b1abfaa8bb819d25d41d71e8e33e25dd36a commit (x86-64: Move vread_tsc
 into a new file with sensible options)
Message-ID: <20110530221908.GA14366@smp.if.uj.edu.pl>
References: <20110530161014.GS25813@smp.if.uj.edu.pl>
 <BANLkTi=7k4XbK6JVDp3oOJRAK_7Ox=aWMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_smp.if.uj.edu.pl-29230-1306793949-0001-2"
Content-Disposition: inline
In-Reply-To: <BANLkTi=7k4XbK6JVDp3oOJRAK_7Ox=aWMw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_smp.if.uj.edu.pl-29230-1306793949-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05-30 16:14, Andrew Lutomirski wrote:
> On Mon, May 30, 2011 at 12:10 PM, Witold Baryluk
> <baryluk@smp.if.uj.edu.pl> wrote:
> > Hi,
> >
> > I found yesterday a problem when booting system on Pentium-M, 32-bit.
> >
> > I got approximetly this
> >
> > [ =A0 =A02.459170] Testing tracer function_graph:
> > [ =A0 =A02.466979] BUG: unable to handle kernel paging request at e421c=
c10
>=20
> >
> > Reverting commit 44259b1abfaa8bb819d25d41d71e8e33e25dd36a on top of cur=
rent
> > kernel make bug disapear.
> >
> > Disabling CONFIG_FUNCTION_GRAPH_TRACER also make bug dispear.
> >
>=20
> Of course, the most trivial of my patches was the one with the most
> significant bug.  Can you try this fix:
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/x86/linux-2.6-tip.git;a=3Dcom=
mitdiff;h=3D89e1be50c68eb5e58b873dce87bbac627ee18d1f
>=20
> --Andy

Fix works. :)

Compiled with patch and CONFIG_FUNCTION_GRAPH_TRACER enabled, and
booted 4 times without problem

[    6.611505] Testing dynamic ftrace ops #1:=20
[    6.771532] Refined TSC clocksource calibration: 3199.859 MHz.
[    6.772337] Switching to clocksource tsc
[    6.919805] (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 215146) (2 2 4 1 215428) PA=
SSED
[    7.058209] Testing dynamic ftrace ops #2: (1 0 1 213422 0) (1 1 2 21370=
4 0) (2 1 3 1 184) (2 2 4 270 453) PASSED
[    7.646890] Testing tracer irqsoff: PASSED
[    7.754403] Testing tracer preemptoff: PASSED
[    7.860605] Testing tracer preemptirqsoff: PASSED
[    7.970927] Testing tracer wakeup: PASSED
[    8.363620] Testing tracer wakeup_rt: PASSED
[    8.763273] Testing tracer function_graph: PASSED
[    9.052030] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    9.061322] VFS: Disk quotas dquot_6.5.2
[    9.065226] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    9.095324] Registering the id_resolver key type
[    9.097664] FS-Cache: Netfs 'nfs' registered for caching
[    9.103503] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    9.111907] fuse init (API version 7.16)
[    9.116706] msgmni has been set to 207
[    9.143692] cryptomgr_test used greatest stack depth: 6452 bytes left
[    9.163685] alg: No test for fcrypt (fcrypt-generic)
[    9.205037] alg: No test for stdrng (krng)
[    9.452480] NET: Registered protocol family 38
[    9.456719] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    9.458912] io scheduler noop registered
[    9.459136] io scheduler deadline registered (default)
[    9.459822] io scheduler cfq registered
[    9.460551] start plist test
[    9.465413] end plist test



Thanks you.

I forgot to check linux-tip/next.

Good work, hope it will land quickly in Linus' tree.


--=20
Witold Baryluk

--=_smp.if.uj.edu.pl-29230-1306793949-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk3kF9sACgkQ7ZLFFOttZ4JUggCgpT6AfWyfktSrF0dSm8wOBd27
AuMAninI583RFUnrtQUPZkYU81miMco8
=3LZK
-----END PGP SIGNATURE-----

--=_smp.if.uj.edu.pl-29230-1306793949-0001-2--
