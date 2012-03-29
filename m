Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307Ab2C2Wum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:50:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58972 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760264Ab2C2Wud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:50:33 -0400
Date: Fri, 30 Mar 2012 09:50:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Neuling <mikey@neuling.org>,
        David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul.gortmaker@windriver.com,
        arnd@arndb.de, hpa@zytor.com
Subject: Re: [GIT PULL] Disintegrate and kill asm/system.h
Message-Id: <20120330095020.a2e01d86c2d09f186c53d63d@canb.auug.org.au>
In-Reply-To: <20120329210117.A9A073E06B4@localhost>
References: <5599.1332958811@redhat.com>
	<30702.1332989444@neuling.org>
	<1332994469.3010.7.camel@pasglop>
	<20120329210117.A9A073E06B4@localhost>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Mar_2012_09_50_20_+1100_DT16rFN1fPm8PV=t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Mar_2012_09_50_20_+1100_DT16rFN1fPm8PV=t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Thu, 29 Mar 2012 15:01:17 -0600 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> Moving it back into powerpc land is a step backwards. I've attached a
> patch that makes it generic instead.  It has been tested on ARM.
>=20
> I've pushed it out to the following branch:
>=20
> git://git.secretlab.ca/git/linux-2.6 irqdomain/merge

I have pulled that into my fixes tree for today (since otherwise my
builds will break).

I have also added this patch to my fixes tree:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 29 Mar 2012 14:58:10 +1100
Subject: [PATCH] powerpc: fix fallout from system.h split up

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/kernel/fadump.c |    2 ++
 arch/powerpc/kernel/kgdb.c   |    1 +
 2 files changed, 3 insertions(+)

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
--=20
1.7.9.5

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__30_Mar_2012_09_50_20_+1100_DT16rFN1fPm8PV=t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPdOcsAAoJEECxmPOUX5FE+N0P/1lN1mz8/T5ugjmfxN5C6q9u
KeXxdRieqZiDnQy5kM9XxSgD1PNg2xdZPhJYgd/LeQV+r76s8x4a+d929VDxhjS8
xMEoS2WdpYBQHauaghzWlM0uviquop5b5IaeX/xVfEBuhZCvHPjpRT2FqbHXwVTG
licbXllz0Mi1YF/mGwpTOT9YaHmrctn/VTRmz/1p03IL2gvOp2C4QM0RPuJAKmd/
eztA2go2ftHSlXR+YxGF+aHzphK5Qelde3t8vGDo6HnQkx9j8AFXc5QTFnZnp/pl
fMhVTn7HElaftphYdMcAM1p3+63XlbzVbPFAjpF4gANernANNafRzeirYw/wlTUr
MRk/BFrkm/HjmiZQv658X+0dwsJpt7OPmxhov+74IDr3Mew1ZsvyCgELsI/EECGP
IrVup//2Shp5gzRpjRtQSZGMnnrIZcSHClPvOvo6it4C7pDHc3IWDbsl4KsY98U5
IqyoRUq/Q6SPcvwGq2Qcc0o5ufs2BI0w5i+sxfuFJhxET51XPNM2O4yPfhoLhK9Q
RpaBCEAWDKN/XhM2Tss5sLN8Q4+LdDoiLMmCs8sihgS6JX0VwL3s35up9+Hkt1+h
oXHO5YlXYQQvGKF099QyNC48ZVO66K0ioCt2b1Tn8hGda0gAjwsmonKkrD1q1Lnw
U6SM/01FAP7xFZoMVkrW
=vTpC
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Mar_2012_09_50_20_+1100_DT16rFN1fPm8PV=t--
