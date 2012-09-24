Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab2IXJt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:49:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57492 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab2IXJtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:49:25 -0400
Date: Mon, 24 Sep 2012 19:49:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: linux-next: manual merge of the arm-soc tree with the fbdev tree
Message-Id: <20120924194921.9c277f5048627c74708ba1ce@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_19_49_21_+1000_D0+e9B/YY82nMG0m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_19_49_21_+1000_D0+e9B/YY82nMG0m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got conflicts in
drivers/video/msm/mddi.c, drivers/video/msm/mdp.c and
drivers/video/msm/mdp_hw.h between commit 8abf0b31e161 ("video: msm:
Remove useless mach/* includes") from the fbdev tree and commit
1ef21f6343ff ("ARM: msm: move platform_data definitions") from the
arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/msm/mddi.c
index d43e178,bf73f04..0000000
--- a/drivers/video/msm/mddi.c
+++ b/drivers/video/msm/mddi.c
@@@ -26,7 -26,10 +26,7 @@@
  #include <linux/clk.h>
  #include <linux/io.h>
  #include <linux/sched.h>
- #include <mach/msm_fb.h>
 -#include <mach/msm_iomap.h>
 -#include <mach/irqs.h>
 -#include <mach/board.h>
+ #include <linux/platform_data/video-msm_fb.h>
  #include "mddi_hw.h"
 =20
  #define FLAG_DISABLE_HIBERNATION 0x0001
diff --cc drivers/video/msm/mdp.c
index 7570908,d1f881e..0000000
--- a/drivers/video/msm/mdp.c
+++ b/drivers/video/msm/mdp.c
@@@ -25,7 -25,8 +25,7 @@@
  #include <linux/major.h>
  #include <linux/slab.h>
 =20
- #include <mach/msm_fb.h>
 -#include <mach/msm_iomap.h>
+ #include <linux/platform_data/video-msm_fb.h>
  #include <linux/platform_device.h>
  #include <linux/export.h>
 =20
diff --cc drivers/video/msm/mdp_hw.h
index 2a84137,a0bacf5..0000000
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@@ -15,7 -15,8 +15,7 @@@
  #ifndef _MDP_HW_H_
  #define _MDP_HW_H_
 =20
- #include <mach/msm_fb.h>
 -#include <mach/msm_iomap.h>
+ #include <linux/platform_data/video-msm_fb.h>
 =20
  struct mdp_info {
  	struct mdp_device mdp_dev;

--Signature=_Mon__24_Sep_2012_19_49_21_+1000_D0+e9B/YY82nMG0m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYCyhAAoJEECxmPOUX5FEG4AP/3fXpnjfZPYJInMuXtW7Hend
XAcECeGiVFodCgFpmf+fNne5oA9kCFE93bSJOwb/b1PxbZJ74aQIFYX4FYlf6pN0
undrK9Qhkw0kdauiEl5Mx4br+xgktKmGX3pJn4ibwiOE5UqLszIErNAAhsFkehbO
LZY3e517zZ1Hcp1uznH34bKeQdnNHc2RMOMt9mVRe/PxeRKCLDEP8bAMiV9G9qVp
/qXYO5G9URNa4lS5Hd9uwIEnLYaTKK2k9HHoPPnwfrKTiIAn1AgLRVjMzp2+gdou
abH1aeVB8lq8mjdwELgyLz0yi8bQAHZUt6Rlux/F7LoohWEN+H6DBvrZRPR/L862
z6YRtQ7sNOm2bG9khTGiVFPedh/axLVJoHlljRN2S+VFKwesQKo3D3AqQ3GseNG1
IADpXCmmOZl3b3JhC7hfxef5GMHysKU06sirTnNyGf9EC1hJ4DWfCevUouN3EHcc
BksKNylbHZ8Bd9/5bC+Gd8WOEg4hh2SpHIiW0Ucnmn1qFUNRzCBgKOWZQQZl5Yk/
M4pYdRk64btq1qUM2654MviOpMCDvwvGiW/Ztb9p1x6cLixuyO8tWsrgFp1KCMsM
rs2jkJ3Sj6eFELsOXN0hddVIRpI6noJCY/qru7h6Os2JRdqriQQhSAd9ZQu3hXau
eIPA4UJp8jfMRjq9X/qb
=MFAK
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_19_49_21_+1000_D0+e9B/YY82nMG0m--
