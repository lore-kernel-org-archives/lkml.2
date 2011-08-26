Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1HZLSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 07:18:49 -0400
Received: from vm4.telegraphics.com.au ([98.124.60.149]:39932 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1HZLSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 07:18:47 -0400
Date: Fri, 26 Aug 2011 21:21:05 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Brad Boyer <flar@allandria.com>, Linux/m68k <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: Convert to genirq (WIP)
In-Reply-To: <CAMuHMdXgeHtOB_3u6G6N9E4vaq=sJY-9NtF68XAnxhspMgRyGg@mail.gmail.com>
Message-ID: <alpine.OSX.2.00.1108262117070.267@ibook.local>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg> <alpine.OSX.2.00.1106011300550.199@ibook.intranet> <20110605062702.GA2034@cynthia.pants.nu> <CAMuHMdXVt5+nCaCSH3+z0fsL+vhOOTgbKsOAses8OudT-1OZGQ@mail.gmail.com> <alpine.OSX.2.00.1108102007430.203@ibook.local>
 <CAMuHMdXgeHtOB_3u6G6N9E4vaq=sJY-9NtF68XAnxhspMgRyGg@mail.gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-701206178-1314355471=:267"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-701206178-1314355471=:267
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Fri, 26 Aug 2011, Geert Uytterhoeven wrote:

> On Wed, Aug 10, 2011 at 12:53, Finn Thain <fthain@telegraphics.com.au> wr=
ote:
> >> via1_irq
> >> =C2=A0 =C2=A0 OSS_IRQLEV_VIA1 =3D IRQ_AUTO_6 (on oss) =C2=A0 =C2=A0 =
=C2=A0 conflict: psc_irq
> >>
> >> =C2=A0 =C2=A0 IRQ_AUTO_1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0co=
nflict: iop_ism_irq
>=20
> >> iop_ism_irq
> >> =C2=A0 =C2=A0 OSS_IRQLEV_IOPISM =3D 1 =3D IRQ_AUTO_1 (on oss) conflict=
: via1_irq
> >
> > via1_irq is remapped to IRQ_AUTO_6 on OSS.
>=20
> According to via_register_interrupts(), it requests both:
>=20
>         if (via_alt_mapping) {
>                 if (request_irq(IRQ_AUTO_1, via1_irq, 0, "software",
>                                 (void *)via1))
>                         pr_err("Couldn't register %s interrupt\n", "softw=
are");
>                 if (request_irq(IRQ_AUTO_6, via1_irq, 0, "via1", (void *)=
via1))
>                         pr_err("Couldn't register %s interrupt\n", "via1"=
);
>         } else {
>                 if (request_irq(IRQ_AUTO_1, via1_irq, 0, "via1", (void *)=
via1))
>                         pr_err("Couldn't register %s interrupt\n", "via1"=
);
>         }
>=20
> Hence IRQ_AUTO_1 must be shared and we cannot use an optimized chain
> handler for via1_irq()

I'm pretty sure that the "software" request_irq can be removed. It has=20
come up before --
http://marc.info/?l=3Dlinux-mac68k&m=3D110973724208746&w=3D2

Maybe Brad can shed some light on this (?)

I've just cloned and built your m68k-genirq branch. I will run some tests.

> nor iop_ism_irq().

via_register_interrupts() is not called on OSS.

Finn

> This is the only remaining conflict I see.
>=20
> Gr{oetje,eeting}s,
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Geert
>=20
--0-701206178-1314355471=:267--
