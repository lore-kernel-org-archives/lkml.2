Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab2AEDsw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:48:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63363 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab2AEDsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:48:32 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=bab-uAsQliIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=7Q7WaODTNZKRxum0iW0A:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=bUx_TNEEFFt8TVtH6LcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120105034827.136096207@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 04 Jan 2012 22:48:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 20/20] ktest: Add INGORE_ERRORS to ignore warnings in boot up
References: <20120105034755.793909214@goodmis.org>
Content-Disposition: inline; filename=0020-ktest-Add-INGORE_ERRORS-to-ignore-warnings-in-boot-u.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When testing a kernel that has warnings, ktest.pl will fail the test
when it sees the warning. If you need to test the the kernel and want
to ignore the errors that are produced, the option IGNORE_ERRORS has
been added. When IGNORE_ERRORS is set to something other than 0, it will
ignore call traces due to WARN_ON().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    |    4 +++-
 tools/testing/ktest/sample.conf |    8 ++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index f81c8b3..62a134d 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -104,6 +104,7 @@ my $start_minconfig;
 my $start_minconfig_defined;
 my $output_minconfig;
 my $ignore_config;
+my $ignore_errors;
 my $addconfig;
 my $in_bisect =3D 0;
 my $bisect_bad_commit =3D "";
@@ -218,6 +219,7 @@ my %option_map =3D (
     "BISECT_SLEEP_TIME"		=3D> \$bisect_sleep_time,
     "PATCHCHECK_SLEEP_TIME"	=3D> \$patchcheck_sleep_time,
     "IGNORE_WARNINGS"		=3D> \$ignore_warnings,
+    "IGNORE_ERRORS"		=3D> \$ignore_errors,
     "BISECT_MANUAL"		=3D> \$bisect_manual,
     "BISECT_SKIP"		=3D> \$bisect_skip,
     "CONFIG_BISECT_GOOD"	=3D> \$config_bisect_good,
@@ -1529,7 +1531,7 @@ sub monitor {
 	}
=20
 	if ($full_line =3D~ /call trace:/i) {
-	    if (!$bug && !$skip_call_trace) {
+	    if (!$ignore_errors && !$bug && !$skip_call_trace) {
 		$bug =3D 1;
 		$failure_start =3D time;
 	    }
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.c=
onf
index d7148f7..e711902 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -741,6 +741,14 @@
 # (default 0)
 #IGNORE_UNUSED =3D 1
=20
+# When testing a kernel that happens to have WARNINGs, and call
+# traces, ktest.pl will detect these and fail a boot or test run
+# due to warnings. By setting this option, ktest will ignore
+# call traces, and will not fail a test if the kernel produces
+# an oops. Use this option with care.
+# (default 0)
+#IGNORE_ERRORS =3D 1
+
 #### Per test run options ####
 # The following options are only allowed in TEST_START sections.
 # They are ignored in the DEFAULTS sections.
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPBR2LAAoJEIy3vGnGbaoARVwQAIrZ8M7kYIpjVoZKatmtDX+r
rVKyNzdmi18rFcQ4rbOqIhoOM7MGgtZ0/VVmacub48MGG58SzNtz7jbTDADsCTnV
4/YCi8+sVZT8hVShLGM0Z3Hvd/tGnQnWccMlZhS78FSTVFs/DF/XCsHvhRjIGb75
rbOLA10sth2+rxza5FdOwf8FeEM6PhWrJRFelkG3PeESU23pKLxeOFYh8deZqwHT
39F9ddFLYbn/9v8J/9gjLJznKw2yyUki9TOKEFYBgQVE1LVJ/eYpMdsuHKvGPhh2
yorCrnDoAmRrjS0ZjhpGx/368ex/vPr+61JcnLdvRhdxFV1ZdNUy7HLBq/ZjVCSk
PduY3JdCWiXE/nuJQi5nCyhV9szcDtxaTxWp0RpeauXt/jkxXYcohb56RqTX4Bpi
2E0F/QG/zmzSMHtAcQyWR2Dr33s25Jn+FcueBQTSlufS5fq+V9FQQRKjZQN73IvZ
IR0zA2MHuxXERhpiGixCEahe0i6230t+cv2cwrLxT/3St+QylNlOIeRpjuNQ2Cdz
b8VuWfedDVYz/kra0gPPJI6gvI5TA/qrDw3TFlDZ+LBy1EA5k4OQRgIp6gZUpTkJ
yZsFJYCXIG6ZhkxRCeBuEV1hOq1UKt+e01IM4P4soa7QvhCiDGu5pmxvGE7DIwWa
r9C7oL3J1FZskudcnoJW
=Fh77
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
