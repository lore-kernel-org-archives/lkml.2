Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab0LGB6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 20:58:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48811 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab0LGB6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 20:58:33 -0500
Date: Tue, 7 Dec 2010 12:58:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the final tree (tip
 tree related)
Message-Id: <20101207125822.1d43e572.sfr@canb.auug.org.au>
In-Reply-To: <20101129143047.GM18100@redhat.com>
References: <20101122133949.93201b15.sfr@canb.auug.org.au>
	<20101129135023.4a931f86.sfr@canb.auug.org.au>
	<20101129082916.GA12374@elte.hu>
	<20101129143047.GM18100@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Dec_2010_12_58_22_+1100_kWJ_N8pQ2J7ulh/7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Dec_2010_12_58_22_+1100_kWJ_N8pQ2J7ulh/7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Nov 2010 09:30:47 -0500 Don Zickus <dzickus@redhat.com> wrote:
>
> On Mon, Nov 29, 2010 at 09:29:16AM +0100, Ingo Molnar wrote:
> >=20
> > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >=20
> > > On Mon, 22 Nov 2010 13:39:49 +1100 Stephen Rothwell <sfr@canb.auug.or=
g.au> wrote:
> > > >
> > > > After merging the final tree, today's linux-next build (sparc64 def=
config)
> > > > failed like this:
> > > >=20
> > > > arch/sparc/kernel/nmi.c:54: error: redefinition of 'touch_nmi_watch=
dog'
> > > > include/linux/nmi.h:21: note: previous definition of 'touch_nmi_wat=
chdog' was here
> > > >=20
> > > > Caused (or, at least exposed) by commit
> > > > 5f2b0ba4d94b3ac23cbc4b7f675d98eb677a760a ("x86, nmi_watchdog: Remov=
e the
> > > > old nmi_watchdog").  Sparc appears to have a touch_nmi_watchdog() a=
nd
> > > > defines ARCH_HAS_NMI_WATCHDOG but not CONFIG_HARDLOCKUP_DETECTOR.
> > > >=20
> > > > I have reverted that commit for today (as well as commit
> > > > 072b198a4ad48bd722ec6d203d65422a4698eae7 "x86, nmi_watchdog: Remove=
 all
> > > > stub function calls from old nmi_watchdog" that depends on it).
> > >=20
> > > This build failure is back, so I have reverted the above commits agai=
n.
> >=20
> > Don, have you got a fix for that?
>=20
> I do.  I posted it last week, but you wanted me to post something
> incremental instead.  I'll get that out today.

I am still reverting those 2 commits.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Dec_2010_12_58_22_+1100_kWJ_N8pQ2J7ulh/7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM/ZS+AAoJEDMEi1NhKgbsvOoIAJeRXbebu22xMOynkzOdVS2Y
8DVid8NH//bhCsKvzA32uffmLbjRJsDlhxrAJ0fSjWsGfB73PAf804NSY6U1pkFz
0IqpOGCMCNNKaKJZguK92snRiS22cr7pzBYGftceXneqJHBVn/RJ6GuS45TrnUQW
tMTr0gP4ppKiBk/Per/moGjNrvyQ+xFj7qFK8bKRtjT7SPuk19xrOHSdrfF1PGxE
54cesBjicv5ngaC4BdDBDEP0QRkEnef17tEciQThWX9DDWrcEBxoqeSaGC+BzqmU
oXtoru65DqboCfWYTRRHBIt9zBf0k/P2NAR/zKCP+Rt0RLNOExjkwoDLW4qVNG4=
=cqfn
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Dec_2010_12_58_22_+1100_kWJ_N8pQ2J7ulh/7--
