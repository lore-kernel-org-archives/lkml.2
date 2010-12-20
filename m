Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab0LTEZO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 23:25:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38677 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab0LTEZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 23:25:12 -0500
Date: Mon, 20 Dec 2010 15:25:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>
Subject: linux-next: build warnings after merge of the mfd tree
Message-Id: <20101220152505.f9974119.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__20_Dec_2010_15_25_05_+1100_1A=P3EGgKMAUpEcx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Dec_2010_15_25_05_+1100_1A=P3EGgKMAUpEcx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
produced these warnings:

drivers/gpio/cs5535-gpio.c: In function 'cs5535_gpio_probe':
drivers/gpio/cs5535-gpio.c:269: warning: format '%x' expects type 'unsigned=
 int', but argument 3 has type 'resource_size_t'
drivers/gpio/cs5535-gpio.c:269: warning: format '%x' expects type 'unsigned=
 int', but argument 4 has type 'resource_size_t'
drivers/misc/cs5535-mfgpt.c: In function 'cs5535_mfgpt_probe':
drivers/misc/cs5535-mfgpt.c:320: warning: format '%x' expects type 'unsigne=
d int', but argument 3 has type 'resource_size_t'
drivers/misc/cs5535-mfgpt.c:320: warning: format '%x' expects type 'unsigne=
d int', but argument 4 has type 'resource_size_t'

Introduced by commits d8fefd6ff3a8444ab34f6eb6c7c1961f0ca0008a ("gpio:
Convert cs5535 from pci device to platform device") and
6a85d28cfca9663c0db297a04ca43777dc5bcaa6 ("misc: Convert cs5535-mfgpt
from pci device to platform device").  We have %pR for printing
resources ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__20_Dec_2010_15_25_05_+1100_1A=P3EGgKMAUpEcx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNDtqhAAoJEDMEi1NhKgbsKNUIAIrz5rhdLxrGzaE+t6gL4rWE
nxhB/GzWBG8QDEyld7fzwzwkCg5jchqhCl92uFRkJm7zkAbKrRA0tBoySfbbj3YY
F1PeuHmtBjdf3qpwtTk8aaA8Nuc28cK4WoS/bJSrlw1rt3YHkdAQR4+NC6Pq8U4+
fxhcjQ7oew9oBH/go4aEtO43DRV63zJ/zLAXaUFPisrh7onPU/VnbE/tbNA6QLM9
QEgIUF2CaciaOS4+4i90X5MVTW0ZNCeSK56omUPWR/PuvJV9OrcA9h+TIpitZyMb
CW6ZgGR3fEtv1bbx4ixfmtwsng0PqAFGore8Citm10/QNESHkpmVwtTYCW497Ak=
=WJoV
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Dec_2010_15_25_05_+1100_1A=P3EGgKMAUpEcx--
