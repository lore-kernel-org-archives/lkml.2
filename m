Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab2C2EQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 00:16:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55074 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2C2EQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 00:16:01 -0400
Date: Thu, 29 Mar 2012 15:15:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Michael Neuling <mikey@neuling.org>, David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>, akpm@linux-foundation.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, arnd@arndb.de, hpa@zytor.com,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [GIT PULL] Disintegrate and kill asm/system.h
Message-Id: <20120329151544.ef2117821dfb459e8b52af48@canb.auug.org.au>
In-Reply-To: <20120329135555.06593144b65bf81cc9191f8a@canb.auug.org.au>
References: <5599.1332958811@redhat.com>
	<30702.1332989444@neuling.org>
	<20120329135555.06593144b65bf81cc9191f8a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Mar_2012_15_15_44_+1100_WbAuFOESkuBxVlHq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Mar_2012_15_15_44_+1100_WbAuFOESkuBxVlHq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 29 Mar 2012 13:55:55 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 29 Mar 2012 13:50:44 +1100 Michael Neuling <mikey@neuling.org> wr=
ote:
> >
> > > Here are a bunch of patches to disintegrate asm/system.h into a set o=
f separate
> > > bits to relieve the problem of circular inclusion dependencies.
> > >=20
> > > The following changes since commit 437538267b672f9320833907f1b5acbb26=
05f4be:
> > >=20
> > >   Merge tag 'fbdev-updates-for-3.4' of git://github.com/schandinat/li=
nux-2.6 (2012-03-22 20:43:40 -0700)
> > >=20
> > > are available in the git repository at:
> > >=20
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-asm_sy=
stem.git split-asm-system_h
> >=20
> > It would have been nice to have this in linux-next for a day or two to
> > sort out the merge issues,  hence....
>=20
> Um, what can I say but "yeah, it would have been nice" :-(

The following patch fixes (as much as possible) a powerpc allyesconfig buil=
d.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 29 Mar 2012 14:58:10 +1100
Subject: [PATCH] powerpc: fix fallout from system.h split up

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/kernel/fadump.c |    2 ++
 arch/powerpc/kernel/kgdb.c   |    1 +
 kernel/irq/irqdomain.c       |    3 +++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index cfe7a38..18bdf74 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -40,6 +40,8 @@
 #include <asm/prom.h>
 #include <asm/rtas.h>
 #include <asm/fadump.h>
+#include <asm/debug.h>
+#include <asm/setup.h>
=20
 static struct fw_dump fw_dump;
 static struct fadump_mem_struct fdm;
diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 76a6e40..782bd0a 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -24,6 +24,7 @@
 #include <asm/current.h>
 #include <asm/processor.h>
 #include <asm/machdep.h>
+#include <asm/debug.h>
=20
 /*
  * This table contains the mapping between PowerPC hardware trap types, and
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index af48e59..1f94ddf 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -12,6 +12,9 @@
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/fs.h>
+#ifdef CONFIG_VIRQ_DEBUG
+#include <asm/debug.h>
+#endif
=20
 #define IRQ_DOMAIN_MAP_LEGACY 0 /* driver allocated fixed range of irqs.
 				 * ie. legacy 8259, gets irqs 1..15 */
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__29_Mar_2012_15_15_44_+1100_WbAuFOESkuBxVlHq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPc+HwAAoJEECxmPOUX5FET2oP/2slayQM3wN4DhXAE/v+JeBU
bEmqlZE5DgrAK6Pu65YrlZlYVvfvOsivTwu/tfQ+FLlJHGiPHbVu7zKv/em+cRtz
dTMQSuYolSyRzAyk+QBD4lUN+SZ8OFfs9XbVxhyTCBe+1qdUUdyul4ajrvo9vMiw
+0eHw1WlozwGOdWcYy/9BdHXPVUiJGjWksmGmAQz0aTbTY5DVfKjiEsHIRS+lJ0f
nsrKfWOk5z+4yT2AjteEYcPScxxO2F73VZEr/xBEn5R3siuEgZF6P1n96gTxe/3l
jdKQG6R2QHfKBpx8kphL3qAom5ehese2YaYkufDn4u+/QXtrDoYE/F2a646I7dc3
LN2SCiLLiaba11uW06cfdiwpkrlF05nHJR3CnEUt8dSQbS/vEjxlRHa9V3cl7Y9/
c2rK6z3YQwZXL53LTO4YMv5yaYDathWPKwanGJSocWICq6gbtWl4XevoLRwmkRo1
TuMAj1jy69mxFdiQQA5LO+JRkQN4POo2+vBUb+0RncNrR/tIpp5xB9np30bwIdNI
+VS0I2IQD4VntQp+CF/O/y8SEfyqo/7BWPpZhneRy6LMKC9aOe1RpSgKDa4ZvWYh
BW60vTDNnc5CNSjOtfOtW55m+JH/eY2/Hidy/Yt7PjLXGi+6KKy0eY7Kl6G0PuS1
3/KLLW8Vu3GxBLUWiXZv
=1Nhy
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Mar_2012_15_15_44_+1100_WbAuFOESkuBxVlHq--
