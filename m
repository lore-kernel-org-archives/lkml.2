Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab2EGHPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 03:15:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47654 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab2EGHPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 03:15:07 -0400
Date: Mon, 7 May 2012 17:14:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: linux-next: build failure after merge of the final tree (battery
 tree related)
Message-Id: <20120507171458.5ce17d20c40856e9440b3e5f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_May_2012_17_14_58_+1000_AfXxT2OZ/.sR7nPb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_May_2012_17_14_58_+1000_AfXxT2OZ/.sR7nPb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/power/smb347-charger.c: In function 'smb347_probe':
drivers/power/smb347-charger.c:1039:2: error: implicit declaration of funct=
ion 'IS_ERR' [-Werror=3Dimplicit-function-declaration]
drivers/power/smb347-charger.c:1040:3: error: implicit declaration of funct=
ion 'PTR_ERR' [-Werror=3Dimplicit-function-declaration]

Caused by commit 34298d40e585 ("smb347-charger: Convert to regmap API").

I have reverted that commit for today (and commit fcc015cda7df
"smb347-charger: Clean up battery attributes" that conflicted with the
revert).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_May_2012_17_14_58_+1000_AfXxT2OZ/.sR7nPb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPp3ZyAAoJEECxmPOUX5FE53sP/0m5mzqa483m1xg3rpIYlIrL
eDdNPWsRLBI0SaRb5sPipF6xu/1YzCrhyw0/+tZoT9Fw57W9itRXpY2pO6+kWuVS
aIB6gqouwKPCcnmIFzxVcI0LRGT+Q2GQWeGw8dmDhgwTpNfmolKCC9tufyqtRX9R
/FGYIkYjWdH8/M0YRHzN4m09sSdoAy5oCUw1G+mEB5ieEzcBCNWZOxitI78rHxeQ
3442PsOnwdpwUxpxX18XfzQvkfR8jresEnHNu+0ZVps7Y2CPsAb2gUdDUCWjReR/
zVeDPjjJjlsu+DH/lzbx2Q/smmlaoItIA1p5ky//tiORVB43ddd1L627tfiz8t3E
/NnWHXOQC8yuqfPKX3qguQiN4ZLs6Yxokwv0FNxg7NZFWFh0xPrOeIlYEr/oHF3K
cGUuFVkNQZCiWYnFrGO7AzEhgGX2bc9AbXAEADXqVbEfRq3z6wP4VL3/2t8mzOEg
UscVWfIPwgrNUfo48azTkqrgdn3SVWlBKtqj7iirLKPAkyzt954tGO4A4mJor5Fe
BleQ4GoZJs/DO257f9wgaIK3jSV0F74358fHNWgVWayzECTH8vsp+aaUObixmxvk
7ASRBiPCzys5DOR5JtKzj3t3nYxlRQAiQCVbVZ+x0rQH5F+F7amqxIB85xy4Urmg
bWmjbRVfLiOi3b+ck/f+
=4hBe
-----END PGP SIGNATURE-----

--Signature=_Mon__7_May_2012_17_14_58_+1000_AfXxT2OZ/.sR7nPb--
