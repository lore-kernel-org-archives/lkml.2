Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab2AIGAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 01:00:01 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:39007 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2AIF77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 00:59:59 -0500
Date: Mon, 9 Jan 2012 16:59:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20120109165950.53933c3050416bd242acff76@canb.auug.org.au>
In-Reply-To: <20120105160448.dc482ef6.akpm@linux-foundation.org>
References: <20120105190405.1e3191fb5a43b2a0f1655e1f@canb.auug.org.au>
	<20120105160448.dc482ef6.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jan_2012_16_59_50_+1100_nHLKwYuPCU1=3Yvp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jan_2012_16_59_50_+1100_nHLKwYuPCU1=3Yvp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Jan 2012 16:04:48 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Thu, 5 Jan 2012 19:04:05 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > After merging the final tree, today's linux-next build (sparc64 defconf=
ig)
> > failed like this:
> >=20
> > In file included from include/trace/ftrace.h:567:0,
> >                  from include/trace/define_trace.h:86,
> >                  from include/trace/events/power.h:240,
> >                  from kernel/trace/power-traces.c:14:
> > include/trace/events/kmem.h: In function 'ftrace_test_probe_kmalloc':
> > include/trace/events/kmem.h:45:1: error: implicit declaration of functi=
on 'check_trace_callback_type_kmalloc' [-Werror=3Dimplicit-function-declara=
tion]
> > include/trace/events/kmem.h: In function 'ftrace_test_probe_kmem_cache_=
alloc':
> >
> > ...
> >
> > include/trace/events/kmem.h:267:1: error: implicit declaration of funct=
ion 'check_trace_callback_type_mm_page_alloc_extfrag' [-Werror=3Dimplicit-f=
unction-declaration]
> > In file included from include/trace/ftrace.h:774:0,
> >                  from include/trace/define_trace.h:86,
> >                  from include/trace/events/power.h:240,
> >                  from kernel/trace/power-traces.c:14:
> > include/trace/events/kmem.h: In function 'perf_test_probe_mm_page_pcpu_=
drain':
> > include/trace/events/kmem.h:256:1: error: implicit declaration of funct=
ion 'check_trace_callback_type_mm_page_pcpu_drain' [-Werror=3Dimplicit-func=
tion-declaration]
> >=20
> > I have no idea what has gone wrong here, but I did not get this error
> > yesterday.  The only thing that touched include/trace/events/kmem.h is
> > patch "mm-tracepoint: rename page-free events" from the akpm tree, but
> > that was there yesterday as well and doesn't look suspicious.
>=20
> Yes, it's not due to anything in the akpm tree.  Tracing stuff blew up.
>=20
> > I just have to leave things broken for today in the hope that someone
> > figures something out.  This does not affect my X86_64 allmodconfig bui=
ld
> > or my PowerPC builds (including an allyesconfig build).
>=20
> It fails with sparc64 defconfig but succeeds with sparc64 allmodconfig.
> Some config-dependent thing.  3.2 is OK, so it's something in -next.
>=20
> It could be that some far-off sparc64 Kconfig change is newly
> triggering this. =20
>=20
> I suppose I could get off my ass and actually work out why it broke,
> but the tracing code is too icky.

This failure is now in Linus' tree.  I am not sure when it got there.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Jan_2012_16_59_50_+1100_nHLKwYuPCU1=3Yvp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPCoJWAAoJEECxmPOUX5FE6tEP+wVoKMZJSVXqEYxgermxwEzz
8uVWUEbY62O3e133L9rMaNYsrdCBPjeHACZuTfa1epwe0hGKvtyrfOjkOVtJn6Yb
NRhmtOOTx/rF909RlMVPtHr6CAtUkp8Bc9Q88iKmNZlfsP41LEZRyuKrtUwCmg8C
Y/3LeElm50iyz9DdjlMSjHs7RFYxb6byHASl/TOQK+0cqPJtgwunzJCbYbolnUVz
z8Ox8PknBm/OuS+JB91HrOuh6sNLqYHk4zmYE3N9VzBSR0PmS3uvsU/ERnWW+Z9p
T33MBqX3CuNP9qZk6c8rz/u2NjnNazNc0dUrq0TVG9gjM31UchYZIsqATolnamg4
GP2NLZHWSiwOsW2+7dS21BMaN+7SK8exog6Q47ffoo72cjN+ZXeMIfsE5TQJ81xs
+iCEVRSNFZlCdiwdDC2LoGeiP8kBsiM0WktDEyIJLmL0WJgNudY+CRqjsuFmVPBI
ICq/F07yGAMtqYF8NapOh+XlnCJOnSVAHDw2XFPpxl+IvjMZCzCeuBQoI1dk9Dz1
7WTh3CdXg99qZOERSmSRJ2xOWaN3h+uBOm6OrsKOpB2DPFrELtPQdaqHGZ9xJU2k
GcKKbAq22m0uBp0gpqQcymE8T0HdxiHxL3lFi2p+zMRdorTU53dufDTh6i/kD/TO
dI9A7bhTt4gNX0J8Q5a6
=F8Jn
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jan_2012_16_59_50_+1100_nHLKwYuPCU1=3Yvp--
