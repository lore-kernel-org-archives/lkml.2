Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab2CSCOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 22:14:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55918 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab2CSCOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 22:14:08 -0400
Date: Mon, 19 Mar 2012 13:13:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20120319131345.a2f5b9983538d25c2974d344@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Mar_2012_13_13_45_+1100_k9B49Hv5tPUREkEp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Mar_2012_13_13_45_+1100_k9B49Hv5tPUREkEp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/built-in.o: In function `rc5t583_i2c_init':
rc5t583.c:(.init.text+0xb3db): undefined reference to `i2c_register_driver'
drivers/built-in.o: In function `rc5t583_i2c_probe':
rc5t583.c:(.devinit.text+0x8fa0): undefined reference to `regmap_init_i2c'
drivers/built-in.o: In function `rc5t583_i2c_exit':
rc5t583.c:(.exit.text+0x708): undefined reference to `i2c_del_driver'

Caused by commit 1b1247dd75aa ("mfd: Add support for RICOH PMIC
RC5T583"). Presumably some missing Kconfig dependency.

I have ued the version of the mfd tree from next-20120316 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__19_Mar_2012_13_13_45_+1100_k9B49Hv5tPUREkEp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBCAAGBQJPZpZZAAoJEECxmPOUX5FEXPgP+PJSb+DIoGoq5dn9S1l/stFm
tsPjR68Qu5ReHyugwy2xoEaRy9FbpsU3gCAwkDlxZvDlykeX9BnFYCS+2/DTk4f4
kouxIGG0JU7Vuq6RGb/3EK8F51oM8/p9MYa28Twuu4AK6fhLxNYxGGVtFa2Ndxr4
5P+EWREMDIqO0Pp6I2OlvrxkDBztcDSfrxgE56ntgz2TAy1Zu4n13jZDck5rPboY
PzBbqTqRTjAt7fcJwZY4dVOHD1Nny1ZxmTVRXd/pkDAxu+QpJYvzfiUY/Bg8T1xx
EaSQA72jRv7c29foOyBEdNwn/l7lFPdwrjLLQgISJAlRXfY8j+vKO/PVI/zLbFq+
9WSJPYBPSWhzUBbcYizrGAAHbXP+zl5UIlC45/egINjS4ydkefyCYGtCn7zpSSeS
Fh00gvdMpTjNoQ+SGcxvs5d89JGiOsTWyqTUK30TtNMK7Vu1SCHlM7SuARroJkKl
kFqt7JEEDPDTaM6bmR5QWKG3x5F9seg23Q3OQ8I4+iPhUl/OxbL4qvmIUWQlgVV2
2S317wDzEe8ByO/Lkwhagprt8q3NngY0khHjgKYx6bIKuaDUr64YiZS8Fw/6UzLW
oC7wMsrHGBer3tF5WVHF0ur6IEj0q8G9MxYN2Ncg9tnehmmxYFVIEHbz0b+/ZWaz
OsXoRgOjXk+py0head0=
=jrKT
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Mar_2012_13_13_45_+1100_k9B49Hv5tPUREkEp--
