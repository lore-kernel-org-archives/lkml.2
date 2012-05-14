Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab2ENIvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:51:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40038 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab2ENIve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:51:34 -0400
Date: Mon, 14 May 2012 18:51:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the omap_dss2
 tree
Message-Id: <20120514185116.fcde1a3be2fbaae3c4b5f279@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_18_51_16_+1000_wh=t_GIZurbEgZap"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_18_51_16_+1000_wh=t_GIZurbEgZap
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/video/omap2/displays/panel-taal.c between commit 9c3d5eb71b1f
("OMAP: DSS2: Remove suspicous and unused TAAL regulator API usage") from
the omap_dss2 tree and commit 3acc797c1db2 ("OMAPDSS: Taal: move reset
gpio handling to taal driver") from the arm-soc tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/omap2/displays/panel-taal.c
index 3053399,b2dd88b..0000000
--- a/drivers/video/omap2/displays/panel-taal.c
+++ b/drivers/video/omap2/displays/panel-taal.c
@@@ -992,8 -1082,13 +1001,11 @@@ err_gpio
  	if (bldev !=3D NULL)
  		backlight_device_unregister(bldev);
  err_bl:
+ 	if (gpio_is_valid(panel_data->reset_gpio))
+ 		gpio_free(panel_data->reset_gpio);
+ err_rst_gpio:
  	destroy_workqueue(td->workqueue);
  err_wq:
 -	free_regulators(panel_config->regulators, panel_config->num_regulators);
 -err_reg:
  	kfree(td);
  err:
  	return r;
@@@ -1030,6 -1125,12 +1042,9 @@@ static void __exit taal_remove(struct o
  	/* reset, to be sure that the panel is in a valid state */
  	taal_hw_reset(dssdev);
 =20
 -	free_regulators(td->panel_config->regulators,
 -			td->panel_config->num_regulators);
 -
+ 	if (gpio_is_valid(panel_data->reset_gpio))
+ 		gpio_free(panel_data->reset_gpio);
+=20
  	kfree(td);
  }
 =20

--Signature=_Mon__14_May_2012_18_51_16_+1000_wh=t_GIZurbEgZap
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsMeEAAoJEECxmPOUX5FEpqgP/AugiNGMC4279KRGKWea/TbI
6b4AFKHqEgjURiyuUzk4NAfBEaEqBXpUC+iFFKso58Sd7IowtjWEHAdU4BSz5UtW
R8P89y9lsAVZpeeJrJMqJ6TAl1Vel7gEO7l+W5X7d/7nQ9NDU2T28BM46lcgUGiA
R0Caq6LhNr2pJ/20SVWAfpDqck/q6nO5NbN2mE/xT/PJmluEkIHftM/K/mRLfO+Z
FxHCrdpMvIYkhIbL4VOxvvRPyggq0We7/T5LdssP79NtdrPPMKej/27cF1RBMt9C
TgNdSNMPMoU5TkJAI/mEqDSdVkNuWuhZ4QNKKIrlyA8DfQZdRWNXmwYyc8RsoZsu
hRYPwKQA/Qb41LMu5ZVkkaL5G2indVA7E0EvQ+1+76BrlOstlrxbcTRS7ypS8q1J
XL9aWjlLdp/SzmUlGVPs9hD3ywb8P4h3jD5Fg/we3KsMDcnP9u0by7C/E+9MrOhW
K/MQR3Zdt4/7BqcUJ8n/Bofof5BSoKO59jqcCZJkt1CY1DI8TPEs/gb8/+wi9+hg
wuGz131J26uGaO1ftJAffKoAFFBcnbblqyDcNWQ5J1kK95DmYarKgZ+FcOIkAjnK
e4rpaT+LZrifgTN1XDPQvaIEyqL5ltIKYRGtAd3NLNkfAADu1JsLL7l2axofrtVV
F4g7CvF9YgOqIUod2ie6
=nTmo
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_18_51_16_+1000_wh=t_GIZurbEgZap--
