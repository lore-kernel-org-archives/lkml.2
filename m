Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab2GEDwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 23:52:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37225 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2GEDwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 23:52:32 -0400
Date: Thu, 5 Jul 2012 13:52:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: linux-next: manual merge of the input-mt tree with the
 input-current tree
Message-Id: <20120705135220.9f8f95082833a0d6fadeb136@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jul_2012_13_52_20_+1000_rDOlQ7m90iR7LtAr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jul_2012_13_52_20_+1000_rDOlQ7m90iR7LtAr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Henrik,

Today's linux-next merge of the input-mt tree got a conflict in
drivers/input/touchscreen/atmel_mxt_ts.c between commit 9b7e31bbf4bb
("Input: request threaded-only IRQs with IRQF_ONESHOT") from the
input-current tree and commit c2ef9a1a248b ("Input: atmel_mxt_ts - use
client name for irq") from the input-mt tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/input/touchscreen/atmel_mxt_ts.c
index 25fd056,37190ab..0000000
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@@ -1144,13 -1167,8 +1167,9 @@@ static int __devinit mxt_probe(struct i
  	input_set_drvdata(input_dev, data);
  	i2c_set_clientdata(client, data);
 =20
- 	error =3D mxt_initialize(data);
- 	if (error)
- 		goto err_free_object;
-=20
  	error =3D request_threaded_irq(client->irq, NULL, mxt_interrupt,
 -			pdata->irqflags, client->name, data);
 +				     pdata->irqflags | IRQF_ONESHOT,
- 				     client->dev.driver->name, data);
++				     client->name, data);
  	if (error) {
  		dev_err(&client->dev, "Failed to register interrupt\n");
  		goto err_free_object;

--Signature=_Thu__5_Jul_2012_13_52_20_+1000_rDOlQ7m90iR7LtAr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP9Q90AAoJEECxmPOUX5FE5z8QAIlv/Wyc5L1IfJgMFhrRd2Gf
o0CrqJoNtgSNPu55dS33+EQ75JwxlnnK5fapkkMquMFm4xDVc/0U9Gw+GSQu0wI/
f1CcDmq3bJyXQk4eBiyVJel2oHnIH2iLyjg7etulJw1nFFFCUQPizRiht6ssDWMX
KD0fITR+Fp2q9e62InUi7FGWrOp4YNKRTuYWQ7Tye24BSVCMXnzXdu8Wx/N1wys1
GzovF9+VaWEXN6bybHNi4kmP7Ud2SgqltulaJl8p+R9fcmKteg7g1/m0PV4QwJn7
76G7u7D0JQnxzK+J9QxYAqvSfaA9+mSAcC5dNajTdFDGbsVDNsZSVINzF/GLmamN
UAspWNGY6dYT6JCoEbT1toTkT+ctudpnj2gOBYG5EJey6gLkHq+4qKGCghiUekdl
g9KAyA+wtd+EO7e+4IVVcy8KQGbHAAl/YI1NKDYCxDZBz6iB+2+3gKKWJMHbN9h4
rQXqSfVoXfDdV6TLw882PxuxzNKjwmraGLyy8Nw3c/Ac/XSDvLp7Icigcgs3GAsN
bhlUlvIMNo3xTPqA1hPhc9KYoKa8Gykv1ViDEP7sMRZNx7pAG6v15BFUgaK33JYn
syEPRCaym7v8VkuL6IM6pCl7nZpqHRRttB76Khlc2odd9RNP/kZ3dnCzBnRtNI9a
sBaATIMkEypo53YtScQZ
=r5Xv
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jul_2012_13_52_20_+1000_rDOlQ7m90iR7LtAr--
