Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab2AIQ1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:27:11 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:54509 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab2AIQ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:27:09 -0500
Date: Tue, 10 Jan 2012 03:26:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20120110032654.a7bfdc1155b80bf15e318b41@canb.auug.org.au>
In-Reply-To: <20120109154259.GD9329@kroah.com>
References: <20120105190405.1e3191fb5a43b2a0f1655e1f@canb.auug.org.au>
	<20120105160448.dc482ef6.akpm@linux-foundation.org>
	<20120109165950.53933c3050416bd242acff76@canb.auug.org.au>
	<20120109172016.2496b94ce207c5f7f750a1ea@canb.auug.org.au>
	<20120109154259.GD9329@kroah.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Jan_2012_03_26_54_+1100__izZr_OxKUG7mDJu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jan_2012_03_26_54_+1100__izZr_OxKUG7mDJu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, 9 Jan 2012 07:42:59 -0800 Greg KH <greg@kroah.com> wrote:
>
> On Mon, Jan 09, 2012 at 05:20:16PM +1100, Stephen Rothwell wrote:
> > On Mon, 9 Jan 2012 16:59:50 +1100 Stephen Rothwell <sfr@canb.auug.org.a=
u> wrote:
> > >
> > > On Thu, 5 Jan 2012 16:04:48 -0800 Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> > > >
> > > > On Thu, 5 Jan 2012 19:04:05 +1100
> > > > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > >=20
> > > > > After merging the final tree, today's linux-next build (sparc64 d=
efconfig)
> > > > > failed like this:
> > > > >=20
> > > > > In file included from include/trace/ftrace.h:567:0,
> > > > >                  from include/trace/define_trace.h:86,
> > > > >                  from include/trace/events/power.h:240,
> > > > >                  from kernel/trace/power-traces.c:14:
> > > > > include/trace/events/kmem.h: In function 'ftrace_test_probe_kmall=
oc':
> > > > > include/trace/events/kmem.h:45:1: error: implicit declaration of =
function 'check_trace_callback_type_kmalloc' [-Werror=3Dimplicit-function-d=
eclaration]
> > > > > include/trace/events/kmem.h: In function 'ftrace_test_probe_kmem_=
cache_alloc':
> > > > >
> > > > > ...
> > > > >
> > > > > include/trace/events/kmem.h:267:1: error: implicit declaration of=
 function 'check_trace_callback_type_mm_page_alloc_extfrag' [-Werror=3Dimpl=
icit-function-declaration]
> > > > > In file included from include/trace/ftrace.h:774:0,
> > > > >                  from include/trace/define_trace.h:86,
> > > > >                  from include/trace/events/power.h:240,
> > > > >                  from kernel/trace/power-traces.c:14:
> > > > > include/trace/events/kmem.h: In function 'perf_test_probe_mm_page=
_pcpu_drain':
> > > > > include/trace/events/kmem.h:256:1: error: implicit declaration of=
 function 'check_trace_callback_type_mm_page_pcpu_drain' [-Werror=3Dimplici=
t-function-declaration]
> > > > >=20
> > > > > I have no idea what has gone wrong here, but I did not get this e=
rror
> > > > > yesterday.  The only thing that touched include/trace/events/kmem=
.h is
> > > > > patch "mm-tracepoint: rename page-free events" from the akpm tree=
, but
> > > > > that was there yesterday as well and doesn't look suspicious.
> > > >=20
> > > > Yes, it's not due to anything in the akpm tree.  Tracing stuff blew=
 up.
> > > >=20
> > > > > I just have to leave things broken for today in the hope that som=
eone
> > > > > figures something out.  This does not affect my X86_64 allmodconf=
ig build
> > > > > or my PowerPC builds (including an allyesconfig build).
> > > >=20
> > > > It fails with sparc64 defconfig but succeeds with sparc64 allmodcon=
fig.
> > > > Some config-dependent thing.  3.2 is OK, so it's something in -next.
> > > >=20
> > > > It could be that some far-off sparc64 Kconfig change is newly
> > > > triggering this. =20
> > > >=20
> > > > I suppose I could get off my ass and actually work out why it broke,
> > > > but the tracing code is too icky.
> > >=20
> > > This failure is now in Linus' tree.  I am not sure when it got there.
> >=20
> > Bisected down to:
> >=20
> > 8a25a2fd126c621f44f3aeaef80d51f00fc11639 is the first bad commit
> > commit 8a25a2fd126c621f44f3aeaef80d51f00fc11639
> > Author: Kay Sievers <kay.sievers@vrfy.org>
> > Date:   Wed Dec 21 14:29:42 2011 -0800
> >=20
> >     cpu: convert 'cpu' and 'machinecheck' sysdev_class to a regular sub=
system
>=20
> How is this triggering this build problem?  I didn't see this happen
> before, and it wasn't showing up in linux-next in the past, right?

I think this error showed up the first time that the sysdev removal stuff
was included in linux-next i.e. after the other errors/warnings had been
dealt with.

> This patch has nothing to to with tracing, perhaps it is an #include
> file problem?  Or is the build error a different one (remember the
> -Werror problem in linux-next that I fixed up for PPC?)
>=20
> confused,

The tracing code is obscure and I suspect that there may be some ordering
issue in there.  What seems to have triggered this is the include of
device.h instead of sysdev.h in cpu.h.  This has caused a whole lot more
tracepoints(?) to be defined.

So it is a side effect and needs the tracing guys to track it down :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__10_Jan_2012_03_26_54_+1100__izZr_OxKUG7mDJu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPCxVOAAoJEECxmPOUX5FEEQwP/jxcvJAn0pFuCzzbx8ghiD3i
h8b3gpl4yeZX/Om3RhTvSr/4XElh891gbp15YAdmoHjbqa+U3GmtYZJBfNePLhto
zyqNLpzPEEubwG2v80yKvQ7XtJSlLcOSFzVk9pocb8GHqqxkOXQ5BMLpM2s4jCoc
qRoGg5ISnbsYBmcb9enJ5jRZj9NS5wx7w6Pfk6XaY3kGBYHPu6sglVC4Hue96xHU
7FMOeaWpV73CP50kW2DEmXK+nK5VTDDfiIxV+r8bniKlJN/DB9HYbnmfXX60Whp0
xoEK2fOSNqGF0ltcElqpREqgLx8Tlga5SgrNeruX9ABgGb3wfuD/MLsgZbQnh1Ck
A+EVdhTT6+YSd/bFT6W+x4n2rxSxbw7dRU2QaqXNJfT5IyGDtGsEkWQBpQZoFo2b
RivpfqxvaIHgWQKp53tr289GB/IeV74OvTLpgDbaS5vjAGHW0XNcDvcxgWuZBhso
TfAf30myXulS8JweJcJ+gP/yXdWjNAe+UZQzobJvn7j2xW0oeoLnx/FZdFtod0Z8
GI6tD2VFWyWUWR6NdTzHo7iArLTz65v0+fiKb2wsR6skWoOEdB2wCrWPYMcMBb4t
UJh6on925cb0ZdZkCx9AhqSBXkxCnCvgCqHlQgDbnzBGBk4k2Q5tq8A2r0G6N+5a
0DVaXDCov91q2j6Xb9vi
=E7Bn
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jan_2012_03_26_54_+1100__izZr_OxKUG7mDJu--
