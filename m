Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab2EIWeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:34:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab2EIWeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:34:19 -0400
Date: Wed, 9 May 2012 18:34:06 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Matt Turner <mattst88@gmail.com>
cc: torvalds@linux-foundation.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 5/5] PA-RISC: fix compile errors
In-Reply-To: <CAEdQ38H4MjAGKYW3jbcRs98qKnikPwgN_0k2KWbK8wLmJa8xxQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1205091832420.1272@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205091758310.1272@file.rdu.redhat.com>
 <Pine.LNX.4.64.1205091816470.1272@file.rdu.redhat.com>
 <Pine.LNX.4.64.1205091817170.1272@file.rdu.redhat.com>
 <Pine.LNX.4.64.1205091818160.1272@file.rdu.redhat.com>
 <Pine.LNX.4.64.1205091818430.1272@file.rdu.redhat.com>
 <CAEdQ38H4MjAGKYW3jbcRs98qKnikPwgN_0k2KWbK8wLmJa8xxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="185242623-560017539-1336602846=:1272"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185242623-560017539-1336602846=:1272
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 9 May 2012, Matt Turner wrote:

> On Wed, May 9, 2012 at 6:19 PM, Mikulas Patocka <mpatocka@redhat.com> wro=
te:
> > From: Rolf Eike Beer <eike-kernel@sf-tec.de>
> >
> > This was defined in asm/pdc.h which needs to include asm/page.h for
> > __PAGE_OFFSET. This leads to an include loop so that page.h eventually =
will
> > include pdc.h again. While this is no problem because of header guards,=
 it is
> > a problem because some symbols may be undefined. Such an error is this:
> >
> > In file included from /home/buildbot/repos/linux/include/linux/bitops.h=
:35:0,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from /home/buildbot/repos/linux/include=
/asm-generic/getorder.h:7,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from /home/buildbot/repos/linux/arch/pa=
risc/include/asm/page.h:162,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from /home/buildbot/repos/linux/arch/pa=
risc/include/asm/pdc.h:346,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from /home/buildbot/repos/linux/arch/pa=
risc/include/asm/processor.h:16,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from /home/buildbot/repos/linux/arch/pa=
risc/include/asm/spinlock.h:6,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from /home/buildbot/repos/linux/arch/pa=
risc/include/asm/atomic.h:20,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from /home/buildbot/repos/linux/include=
/linux/atomic.h:4,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from /home/buildbot/repos/linux/include=
/linux/sysfs.h:20,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from /home/buildbot/repos/linux/include=
/linux/kobject.h:21,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from /home/buildbot/repos/linux/include=
/linux/device.h:17,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from /home/buildbot/repos/linux/include=
/linux/eisa.h:5,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from /home/buildbot/repos/linux/arch/pa=
risc/kernel/pci.c:11:
> > /home/buildbot/repos/linux/arch/parisc/include/asm/bitops.h: In functio=
n "set_bit":
> > /home/buildbot/repos/linux/arch/parisc/include/asm/bitops.h:82:2: error=
: implicit declaration of function "_atomic_spin_lock_irqsave" [-Werror=3Di=
mplicit-function-declaration]
> > /home/buildbot/repos/linux/arch/parisc/include/asm/bitops.h:84:2: error=
: implicit declaration of function "_atomic_spin_unlock_irqrestore" [-Werro=
r=3Dimplicit-function-declaration]
> >
> > Signed-off-by: Rolf Eike Beer <eike-kernel@xxxxxxxxx>
>=20
> Email address got eaten?

I was copying the patch from mailing list web archive and it mangles=20
addresses. I fixed the others addresses, but forgot about this one.

Mikulas

> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>=20
--185242623-560017539-1336602846=:1272--
