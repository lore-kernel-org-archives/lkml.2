Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934367Ab2JXDoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:44:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48310 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056Ab2JXDoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:44:14 -0400
Date: Wed, 24 Oct 2012 14:44:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Youquan Song <youquan.song@intel.com>, Rik van Riel <riel@redhat.com>
Subject: linux-next: build failure after merge of the final tree (pm tree
 related)
Message-Id: <20121024144400.f5779e119f248256aa183ef5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__24_Oct_2012_14_44_00_+1100_CioZcgRm4DEC_4w4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Oct_2012_14_44_00_+1100_CioZcgRm4DEC_4w4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

In file included from arch/powerpc/kernel/idle.c:27:0:
include/linux/tick.h: In function 'menu_hrtimer_cancel':
include/linux/tick.h:148:48: error: 'return' with a value, in function retu=
rning void [-Werror]

Several of these :-(

Caused by commit 25d77b76d7ae ("cpuidle: Quickly notice prediction
failure for repeat mode") from the pm tree.  This build has
CONFIG_CPU_IDLE_GOV_MENU turned off.  For changes that are obviously
affected by CONFIG options, please test build with the CONFIG option on
and off.

I have applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 24 Oct 2012 14:40:47 +1100
Subject: [PATCH] cpuidle: fix up but return type for inline function

Fixes this error when CONFIG_CPU_IDLE_GOV_MENU is not enabled:

In file included from arch/powerpc/kernel/idle.c:27:0:
include/linux/tick.h: In function 'menu_hrtimer_cancel':
include/linux/tick.h:148:48: error: 'return' with a value, in function retu=
rning void [-Werror]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/tick.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 8867424..40d123e 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -145,7 +145,7 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *=
unused) { return -1; }
 # ifdef CONFIG_CPU_IDLE_GOV_MENU
 extern void menu_hrtimer_cancel(void);
 # else
-static inline void menu_hrtimer_cancel(void) { return -1; }
+static inline void menu_hrtimer_cancel(void) { }
 # endif /* CONFIG_CPU_IDLE_GOV_MENU */
=20
 #endif
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__24_Oct_2012_14_44_00_+1100_CioZcgRm4DEC_4w4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQh2QAAAoJEECxmPOUX5FE9mkP/0k7OOyGRLlRiAbt5WHanRrN
RBxwzLpiTBsW6VMRn/lGpTpgMUkts//KhdPhJCUG9/Kn6G6FcjFF7AoR82AqwhjP
XYjlRaoKQSJcFkd+HNFls+5qIgIs2QLal9buq/g/Fj9dKzHSprTyHKQsH/hUnvNK
OrXUd1EgNlVMJnnKKs7NXIHCVUvkyojbuFru87WKWrwg3iNYyeSSAA19H3W50Mgs
k8u5uUjBc7Dy58xvMh4Rkt43r4SGgVYE/8lhDmvV2yEbZ1nx/XXb/eDZDMZJzeWg
zGr7l6gpTBJHxISTQX3GiJR068sqrViByU56Q94+tgkzvaEwldSwLsHFx9af/egq
CQtYENtWQf0GxX5YjQVZG+LPZMHwBAPUT6wIlJnRsfN2O3FdjH5Gec6o0WgNIwap
/Jmi1bzd30r6pHcTLkxUIgtN5OflxzqM7wNjyzfipmgSg20daxGDuCGauEM/mAcU
c0pAL4U42VvkPz/OVvlLUFnVulJmTuDlyJ5s0GfZl6KYaowDaqqXaS4S2tJjeeU2
K6icRoyn19r9e/u0BWZSvL1zil1LEQql+8qDoISE2Nm6SaWJx25G9Lqq1dRCz7ED
YsI9eePRlansqt7x7ggmomVa5coHr4/5Bd4MHqdcmI7JwgHbekw9f6QeHNMGv3sh
m8mfjN/wSoiWE5YJAicZ
=xCF4
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Oct_2012_14_44_00_+1100_CioZcgRm4DEC_4w4--
