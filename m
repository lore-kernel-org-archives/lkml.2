Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab1BUFhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 00:37:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33638 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424Ab1BUFhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 00:37:39 -0500
Date: Mon, 21 Feb 2011 16:37:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kim B. Heino" <Kim.Heino@bluegiga.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build warning after merge of the driver-core tree
Message-Id: <20110221163727.0addb3ab.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__21_Feb_2011_16_37_27_+1100_IUy6uVSuOV6PK1vo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Feb_2011_16_37_27_+1100_IUy6uVSuOV6PK1vo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/rtc/rtc-m41t94.c: In function 'm41t94_remove':
drivers/rtc/rtc-m41t94.c:139: warning: passing argument 1 of 'platform_get_=
drvdata' from incompatible pointer type
include/linux/platform_device.h:133: note: expected 'const struct platform_=
device *' but argument is of type 'struct spi_device *'

Revealed by commit 71d642908d4e8e7a2a4a6e0490432e719ff466d5 ("Driver
core: convert platform_{get,set}_drvdata to static inline functions").
The warning is in code introduced by commit
8fc2c767b06067b417c565c4e75731e68ed41fd8 ("rtc: add support for ST M41T94
SPI RTC").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__21_Feb_2011_16_37_27_+1100_IUy6uVSuOV6PK1vo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNYfoXAAoJEDMEi1NhKgbsxmUIAJwC525mIBNUbs/NK0+L90E/
4ZKtu4a2S9UX2U0EOC7vZPjoTo7n4zxZMN3k+WHGfU52Fi/ZCyWWWMhhfosiDXs8
fC7vcm2L4RfgHpmH28svGt2owXDlOzrkUSJK+YoRRuUkYkNLIXpi4pf6mMMSRmmv
hK61FnhwnN/KiV0Rhns3kWOUFqt09wnzX5o0xPlq2Ec3TjKmZG+a4Y0D1ROVLCMb
79MnwGB0rZ8gImA/ZWtglx7b/4Av7d6XAg37wJ1rA8dzAs2ge0ZcliTX3+6HKTBF
Ei8l1czwRrDwe1rDoZD81Y1hLvaeT+cKWEDslaX1uiqMcQLSR27PjdR58Xdi9xY=
=X2eZ
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Feb_2011_16_37_27_+1100_IUy6uVSuOV6PK1vo--
