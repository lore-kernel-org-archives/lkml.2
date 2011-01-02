Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab1ABWAV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 17:00:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41058 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892Ab1ABWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 17:00:20 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, 599368@bugs.debian.org,
        608138@bugs.debian.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FLEmYEYYA0CfvRAg/B9S"
Date: Sun, 02 Jan 2011 22:00:10 +0000
Message-ID: <1294005610.3167.99.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] watchdog: Improve failure message and documentation
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FLEmYEYYA0CfvRAg/B9S
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The error message 'NMI watchdog failed to create perf event...'
currently prints the error value as a pointer, rather than extracting
the error code with PTR_ERR().  Fix that.

Add a note about the 'nowatchdog' kernel parameter to associate it
with this message.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/kernel-parameters.txt |    2 +-
 kernel/watchdog.c                   |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-par=
ameters.txt
index 7d0cead..6fc0cf4 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1764,7 +1764,7 @@ and is between 256 and 4096 characters. It is defined=
 in the file
=20
 	nousb		[USB] Disable the USB subsystem
=20
-	nowatchdog	[KNL] Disable the lockup detector.
+	nowatchdog	[KNL] Disable the lockup detector (NMI watchdog).
=20
 	nowb		[ARM]
=20
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index d74e866..5b44d2c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -366,7 +366,8 @@ static int watchdog_nmi_enable(int cpu)
 		goto out_save;
 	}
=20
-	printk(KERN_ERR "NMI watchdog failed to create perf event on cpu%i: %p\n"=
, cpu, event);
+	printk(KERN_ERR "NMI watchdog failed to create perf event on cpu%i: %ld\n=
",
+	       cpu, PTR_ERR(event));
 	return PTR_ERR(event);
=20
 	/* success path */
--=20
1.7.2.3



--=-FLEmYEYYA0CfvRAg/B9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATSD1Zee/yOyVhhEJAQLNkxAA1IaVgXrcckJCsXaex0QMtfzFrY8ts20P
kUeTPWicyNcY9vBXo4ovQfBv6Z3Ddc3LWaWvz0oyz6btrHbltobuoB6RtAngUPAB
1SyA4LAzD83J5DdkpJsfdw3f4wk4KEDZqyW0ASWXt/dLuwOM6+lFXZQczj1JdDZb
G1N9b7UmSNw4YHq7CIJR8H2rNDNS67nRtEgvd16xxKJqP5fufqfGuCCLE3DtnkFa
4wRezEIIpyQsh96sgdStHc86vBqY5yNHNHXpQJx/Sbb0Zq7erQtjAF6eTgMmRBTt
VZA+g9MayQg/oNf6DaLTt83D0wIhlY6os5qaA4xo4S3MgzM/+hilCubRGs7Zp9Kx
J5pG1LImJUtY6sCqflkcFOGO7S0nnVEkqkQd5xv3IYBvF9UA5I/eQX0QT78OrtCx
KVFm9og+Z7ZiHro2ufhmBRID7kcrYMS8jMdS+/6NNyyn/rEh8rx8NligVKc87bHz
7sSDsibS6SBAtmEct0r+XNrXZjOJHdLqkkoxnJ5Hfdhb9TiPGFqV0vCJ3a4SqYw0
jFi5kYlMRsZdnDvC3eOwgD6qLVZjQcVsH5Rb/4gM3MmD9/W1XJl4vtmpzka14Kty
e8SlnoW7YjsOkHkwfjYbE7Ad6RnniNO1uAjm9Lz06xmgGoHBZqLuNRhz7VR9NHNl
Uci0HHuVo9c=
=WDAr
-----END PGP SIGNATURE-----

--=-FLEmYEYYA0CfvRAg/B9S--
