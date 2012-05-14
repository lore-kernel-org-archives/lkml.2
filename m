Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2ENJYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:24:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:32786 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2ENJYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:24:19 -0400
Date: Mon, 14 May 2012 19:24:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: linux-next: manual merge of the akpm tree with the arm-soc tree
Message-Id: <20120514192404.91f9477851ad8485a2112973@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_19_24_04_+1000_x+CQybGNYxFchvQ5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_19_24_04_+1000_x+CQybGNYxFchvQ5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/clk/Kconfig between commit d269b974e32c ("clk: remove
COMMON_CLK_DISABLE_UNUSED") from the arm-soc tree and commit "clk: remove
redundant depends on from drivers/Kconfig" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clk/Kconfig
index 4864407,4f10a21..0000000
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@@ -23,9 -22,18 +23,8 @@@ config COMMON_CL
  menu "Common Clock Framework"
  	depends on COMMON_CLK
 =20
 -config COMMON_CLK_DISABLE_UNUSED
 -	bool "Disabled unused clocks at boot"
 -	---help---
 -	  Traverses the entire clock tree and disables any clocks that are
 -	  enabled in hardware but have not been enabled by any device drivers.
 -	  This saves power and keeps the software model of the clock in line
 -	  with reality.
 -
 -	  If in doubt, say "N".
 -
  config COMMON_CLK_DEBUG
  	bool "DebugFS representation of clock tree"
- 	depends on COMMON_CLK
  	select DEBUG_FS
  	---help---
  	  Creates a directory hierchy in debugfs for visualizing the clk

--Signature=_Mon__14_May_2012_19_24_04_+1000_x+CQybGNYxFchvQ5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsM80AAoJEECxmPOUX5FE9OgQAJ/p1vvverXlmbAqbsvazIdo
31t9Gp1D/gD3exfxX7HPENazR8Oc6dk/U/ZNMYa25glPdKaRoTk5GiRdhB9DqHfQ
ouPw5PdrHZJtHMjm1/OyXHP3PVd/lTPYviFZCcDDfKHTi4Li9oPYKOHwyS3YRbtg
MXLgY0Z9pVWR08c5TPG0ZaI6qUg1Pd3RRdietO7Z2LHD/BfuVqnislta2aCn6Yaj
5kbOr0WFw/UxxgvC03eefFQHUVRFMNSyybqqtxa7D6sCp7OTPP8rcGGP8naOyThL
lZIF84R5L1hn5eMhmVgLuAOJLQzTzZjppKGPtdsWJtm7UxINjgtI+AhkRNSLQNfo
Y1Epi3I1zb8LXdMAmHE7B7WRbOnlKbHGxZK9U4bPMHGLbfIG74jA1+9JdE3fIq40
OnAPhov2Q3Pc9C6xnW3DDbi1xymJ5VEFEBHf5F89QGVN7+CpJNpXCb9LWhIUUBS5
hyxX34IMgUi7VMzZF9IjhJHp7q3DDBvKRr5hBcKyYpw9RYKnISSMQ24yc2so20yc
iDtddnNSc5EZUtoPVje//c+eZ7tesdfmsM21NsnLRfsmKh24+lPFUIHjQZRBYn5E
k2OuMxPCBpu/OByFJIrKljKzpiH4vf1NvJ5HKKCoYKxVMPgFrk0IqZp1rIYPTJ1z
ZsKSsrVwc99fE5kSbNgg
=LpW4
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_19_24_04_+1000_x+CQybGNYxFchvQ5--
