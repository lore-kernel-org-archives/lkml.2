Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2KLV0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:26:31 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59611 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab2KLV02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:26:28 -0500
Date: Tue, 13 Nov 2012 08:26:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        <linux-sh@vger.kernel.org>
Subject: [PATCH] Centralise CONFIG_ARCH_NO_VIRT_TO_BUS
Message-Id: <20121113082615.2f482eb8835daf46e1f27947@canb.auug.org.au>
In-Reply-To: <CAErSpo6WG2R_8sa=rOmAOci-3iFpDs2NFzNkZYxDnD2oTiMQJg@mail.gmail.com>
References: <ADE657CA350FB648AAC2C43247A983F00206B25884B1@AUSP01VMBX24.collaborationhost.net>
	<CAErSpo6WG2R_8sa=rOmAOci-3iFpDs2NFzNkZYxDnD2oTiMQJg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Nov_2012_08_26_15_+1100_Itf/8c4.wc_KVJZU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Nov_2012_08_26_15_+1100_Itf/8c4.wc_KVJZU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Make if easier for more architectures to select it and thus disable
drivers that use virt_to_bus().

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/Kconfig         |    7 +++++++
 arch/powerpc/Kconfig |    4 +---
 arch/sh/Kconfig      |    4 +---
 arch/sparc/Kconfig   |    4 +---
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 366ec06..9bc00e7 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -271,6 +271,13 @@ config ARCH_WANT_OLD_COMPAT_IPC
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	bool
=20
+config ARCH_NO_VIRT_TO_BUS
+	bool
+	help
+	  An architecture should select this if it cannot (or will not)
+	  implement virt_to_bus().  All new architectures should probably
+	  select this.
+
 config GENERIC_KERNEL_THREAD
 	bool
=20
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a902a5c..8c8fcba 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -87,9 +87,6 @@ config GENERIC_GPIO
 	help
 	  Generic GPIO API support
=20
-config ARCH_NO_VIRT_TO_BUS
-	def_bool PPC64
-
 config PPC
 	bool
 	default y
@@ -101,6 +98,7 @@ config PPC
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select SYSCTL_EXCEPTION_TRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_NO_VIRT_TO_BUS if PPC64
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index babc2b8..9b28793 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -16,6 +16,7 @@ config SUPERH
 	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if (GUSA_RB || CPU_SH4A)
+	select ARCH_NO_VIRT_TO_BUS
 	select PERF_USE_VMALLOC
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_KERNEL_GZIP
@@ -150,9 +151,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
=20
-config ARCH_NO_VIRT_TO_BUS
-	def_bool y
-
 config ARCH_HAS_DEFAULT_IDLE
 	def_bool y
=20
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 9f2edb5..594d9bc 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -21,6 +21,7 @@ config SPARC
 	select SYSCTL_EXCEPTION_TRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	select ARCH_NO_VIRT_TO_BUS
 	select RTC_CLASS
 	select RTC_DRV_M48T59
 	select HAVE_IRQ_WORK
@@ -143,9 +144,6 @@ config GENERIC_GPIO
 	help
 	  Generic GPIO API support
=20
-config ARCH_NO_VIRT_TO_BUS
-	def_bool y
-
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y if SPARC64
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Nov_2012_08_26_15_+1100_Itf/8c4.wc_KVJZU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQoWl3AAoJEECxmPOUX5FETDAQAItH1ujjUafDGf+fTyszR6tX
1AA9ZZFUv2OYSEWl3bmNNf0CpK+s3lSljc4A9e99+lB0fo2pG1zgBERHdqJ2a83V
YcNCDx6mw2poqYzPJGL3l8eCIQ9JGvhhVBHO6WwiKhE7+QHdypaRePMxl7yn8N/y
fTw1BlKBovCysjO+QZPfQhyAjC8nwMc+LIrSucdDnSuFYpTzxL2EX4pZUiHLl/M7
mGp3+Kz+af7AMMmGyiFbmRpEul9CzU6dMoRV2uxX7SGXvzirntZWf4TMJ6L3U1qQ
/vSb+MkE1cDSsDZJTnADzZla9OcRCGELc4hwmfzCkOlekbF4drb6xcnvjZQo5hFs
PczMY0xXurZIoc7OgIB2sVuGFbgnZ2C0287iqBLj2bVtkrA8n/PKYhNvVrwo7BIA
XM15gK7gQEczRFxPZc5EBf+YjuzZYr99uPzmSXp3Lu4d9A3L3AlfS7haqwA7LSih
qHo7DtZz2s5/VJTBR/FXbRfScdiRDSwdMQZiwWKmSui1fkZg6u1Gy+CH+V8CCS0l
tKNHZhkYNXc2o2uQ3YgN6ns5+b+NhOPAmR9xH6mQb73w1dVmq5BYZpmqrUiNYr7g
0piaeNtxSei7KDbeiC3SYH/61Rlldnm9pf96upnxV6jS0P9wEqVBBu5r2UajuRXr
FNWASGrrzjYOarqXxvY1
=2ENX
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Nov_2012_08_26_15_+1100_Itf/8c4.wc_KVJZU--
