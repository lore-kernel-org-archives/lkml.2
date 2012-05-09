Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab2EIDUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 23:20:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab2EIDUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 23:20:51 -0400
Date: Tue, 8 May 2012 23:20:36 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix compile failure on PA-RISC
In-Reply-To: <CA+55aFy2O8KcLC-yGCG2ZRpCpAdZ_T7z-sSme4fMrXG=YNAAhA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1205082259350.16707@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com>
 <20120505115851.1fecbe50@pyramind.ukuu.org.uk> <Pine.LNX.4.64.1205051448400.2623@file.rdu.redhat.com>
 <CA+55aFy2O8KcLC-yGCG2ZRpCpAdZ_T7z-sSme4fMrXG=YNAAhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="185242623-1738749370-1336532840=:16707"
Content-ID: <Pine.LNX.4.64.1205082307210.16707@file.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185242623-1738749370-1336532840=:16707
Content-Type: TEXT/PLAIN; CHARSET=X-UNKNOWN
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.1205082307211.16707@file.rdu.redhat.com>

On Sat, 5 May 2012, Linus Torvalds wrote:

> On Sat, May 5, 2012 at 11:53 AM, Mikulas Patocka <mpatocka@redhat.com> wr=
ote:
> >
> > What NO_IRQ problem do you mean? There is
> > #define NO_IRQ =A0 =A0 =A0 =A0 =A0(-1)
> > in arch/parisc/include/asm/irq.h.
>=20
> That's the one he means.
>=20
> Switching it to zero and testing that things still work would be apprecia=
ted.

It works, but there is plenty of interrupt controllers on PC-RISC and I=20
can only test it on C8000 with IO-SAPIC. I don't know if irq 0 is used on=
=20
some PA-RISC interrupt controller. It would be best if James Bottomley=20
tests it on his set of machines.

> Much code already knows that NO_IRQ is supposed to be zero, and
> there's tons of drivers that just do the (correct!) "if (!dev->irq)"
> kind of thing.
>=20
> Any architecture that has a non-zero NO_IRQ is basically broken.
> Always has been.
>=20
>                     Linus

And what about x86? --- irq 0 is used for timer and there is
void __init setup_default_timer_irq(void)
{
        setup_irq(0, &irq0);
}
in arch/x86/kernel/time.c.

Mikulas
--185242623-1738749370-1336532840=:16707--
