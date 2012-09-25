Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab2IYEar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 00:30:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43537 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2IYEaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 00:30:46 -0400
Date: Tue, 25 Sep 2012 14:30:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        Andre Przywara <andre.przywara@amd.com>
Subject: linux-next: build failure after merge of the pm tree
Message-Id: <20120925143034.f7bda6d8a5a11e87f2e60ef3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_14_30_34_+1000_tD1HtubfqF/.Ls24"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_14_30_34_+1000_tD1HtubfqF/.Ls24
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the pm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/cpufreq/powernow-k8.c: In function 'transition_frequency_pstate':
drivers/cpufreq/powernow-k8.c:991:19: error: 'HW_PSTATE_MASK' undeclared (f=
irst use in this function)
drivers/cpufreq/powernow-k8.c:991:19: note: each undeclared identifier is r=
eported only once for each function it appears in
drivers/cpufreq/powernow-k8.c:992:19: error: 'struct powernow_k8_data' has =
no member named 'max_hw_pstate'
drivers/cpufreq/powernow-k8.c:995:2: error: implicit declaration of functio=
n 'find_khz_freq_from_pstate' [-Werror=3Dimplicit-function-declaration]
drivers/cpufreq/powernow-k8.c:996:8: error: 'struct powernow_k8_data' has n=
o member named 'currpstate'
drivers/cpufreq/powernow-k8.c:1004:2: error: implicit declaration of functi=
on 'transition_pstate' [-Werror=3Dimplicit-function-declaration]
drivers/cpufreq/powernow-k8.c: At top level:
drivers/cpufreq/powernow-k8.c:981:12: warning: 'transition_frequency_pstate=
' defined but not used [-Wunused-function]

The code causing this was removed by commit e1f0b8e9b04a ("cpufreq:
Remove support for hardware P-state chips from powernow-k8") but
reintroduced (presumably incorrectly) by commit d20801be3c11 ("Merge
branch 'master' into linux-next").

I have used the pm tree from next-20120924 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Sep_2012_14_30_34_+1000_tD1HtubfqF/.Ls24
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYTNqAAoJEECxmPOUX5FE4CIP/iPrkqSn8ssFF5dcT/+Vn33s
q0J9hXf4/5E/MmyYTxDB4EA8m+onL1tjOEWEAPFfFh/GqDQ3ji7KlVd8kxIIGtJz
eNe2aR0Vrx9QRkQHp/HRJW4r9VQBqEQjgGxNVgl8DohktFUunTRdS9JEShKedGRq
v+YenBDFjZIqMJuZ0WlTedbM3uAHOT3AJdqK4kVAvf4bPMMFILOrcbpJYvcbXwDF
Ka6kiQJ00Bn8+0qZ+kZlc03wCrsg3UdxDBX6qK/up5a98Bqqnn3p1f10AgzDs06O
9tOJz90mSto8p5uUmCFydhnbPR+IbUh4VD04MvQzbS3in0fg3T3bakxugEbMnh93
yKVqKLjhzzRm7WWrO4Wb2jca4EFQn42p/TePJDWBoTWFglORZqbRP71PZKt3p0oN
6Lh9BFMus/fakeMXvKgneRyjSwbI94VUHascu+yf34hRcpwlHQb7BUVYucwtL+v3
g2K3MQG79Zqi7QybiaNrt56P/DDzxHtktgUA+5RykexUAyd1sbQaCO4d5m6FF3ZO
EDBQ1qC7cW6gxm0Pr33MO5aH6I/LT6amxg6vhL4WPApbxjYSpv1Q/ik7advf5MvA
CdAyyQNJ5ZhodKoIWQEKtm+pcHlAFGK9CgVMJT84fqZ4rN4+UY59kKFZ1Gz9OIzR
ZFA856ZDGBI6de9nky+C
=+Ia3
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_14_30_34_+1000_tD1HtubfqF/.Ls24--
