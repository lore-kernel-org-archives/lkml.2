Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab2IFEyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 00:54:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57018 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2IFEyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 00:54:05 -0400
Date: Thu, 6 Sep 2012 14:53:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        anish kumar <anish198519851985@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: linux-next: build failure after merge of the driver-core tree
 (workqueues tree related)
Message-Id: <20120906145354.b1ddab86fde4fd58e55eb163@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Sep_2012_14_53_54_+1000_RHNv0Fm+5BB4.2a1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Sep_2012_14_53_54_+1000_RHNv0Fm+5BB4.2a1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg, Tejun,

After merging the driver-core tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/extcon/extcon-adc-jack.c: In function 'adc_jack_probe':
drivers/extcon/extcon-adc-jack.c:146:2: error: implicit declaration of func=
tion 'INIT_DELAYED_WORK_DEFERRABLE' [-Werror=3Dimplicit-function-declaratio=
n]

Caused by commit 19939860dcae ("extcon: adc_jack: adc-jack driver to
support 3.5 pi or simliar devices") from the driver-core tree interacting
with commit 203b42f73174 ("workqueue: make deferrable delayed_work
initializer names consistent") from the workqueues tree.

I have added this merge fix patch (no action is required):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 6 Sep 2012 14:45:26 +1000
Subject: [PATCH] extcon: adc_jack: update for INIT_DELAYED_WORK_DEFERRABLE
 name change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/extcon/extcon-adc-jack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-j=
ack.c
index 60ac3fb..725eb5a 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -143,7 +143,7 @@ static int __devinit adc_jack_probe(struct platform_dev=
ice *pdev)
=20
 	data->handling_delay =3D msecs_to_jiffies(pdata->handling_delay_ms);
=20
-	INIT_DELAYED_WORK_DEFERRABLE(&data->handler, adc_jack_handler);
+	INIT_DEFERRABLE_WORK(&data->handler, adc_jack_handler);
=20
 	platform_set_drvdata(pdev, data);
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Sep_2012_14_53_54_+1000_RHNv0Fm+5BB4.2a1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQSCxiAAoJEECxmPOUX5FENuUQAIrs7K2r6CbRtbHJeVsuoY/6
NlLyWKabQnmOWaEroseWZtRZZyXGYYRN7reqApIG6NwsvudwLjON8KDr5iFiGt/+
TBwhXk8DOKM8iMh7csE0j32KS4EopC5pXwrT4bXWhNQQdYPKNzRSXEqQd2Bgrlpn
J+X5qEHDR6z3i0nAMmjwRkspODQSBTz/pEOf/fMUQESNYHOLMCO+EtYNtyRnI3pR
3iAHmxL5bMPwiDYKxZ/h/UvHoeotl+sYkHbzs7xkmrn9BO03tfnFChrVuuvMctxO
q6vJgjUgLyW0JGfYXTm9o42Ng6l7NViKPKxXzjiuM+5naHyyEZGl8O3jU4lrCJPd
6kGDeO4li0/wJhIB1jnq7Wbcm7bwPsX+FfTWkiaEVy1Tynr+8id/b1ct/NcPVlkW
M2+85Z0qzxLj6HPadYC0UzVdcPRB60znfrxU2z/UDkqYWFqt5ZowsijRUFE5YbsZ
JWQYOqVkr6a/R1YV/Y2FgXpKV6fVOqGGUPrVFXTyf4zR2ufJOnTcrURZ1hcR5oIZ
IsxaLU7/8zYrvRQYUcapwpAXMIv+SmQIou0GpD7jm+u/zf0U5m7VEDRwFY7wyc+f
u62KOoGpVEjDSASmnNzS3ODqeSZV2YjP6qX9qnZWx/G5j++UIWWDDetxPzFtsY+o
CNfm8AnFeF9bGd32OyFe
=86LI
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Sep_2012_14_53_54_+1000_RHNv0Fm+5BB4.2a1--
