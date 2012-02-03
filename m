Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab2BCB7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 20:59:35 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56428 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757808Ab2BCB72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 20:59:28 -0500
Date: Fri, 3 Feb 2012 12:59:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the sound-asoc tree
Message-Id: <20120203125902.558e273c84b339957869f281@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__3_Feb_2012_12_59_02_+1100_InIqXKZOh1sZ0uby"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Feb_2012_12_59_02_+1100_InIqXKZOh1sZ0uby
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
sound/soc/codecs/wm5100.c due to a bad merge resolution in commit
05960268bcef ("Merge branch 'for-3.4' into asoc-next") from the
sound-asoc tree which left the conflict unresolved.  :-(

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/soc/codecs/wm5100.c
index c1c351a,72ebbdb..0000000
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@@ -2076,17 -2097,21 +2097,7 @@@ static void wm5100_micd_irq(struct wm51
  			snd_soc_jack_report(wm5100->jack, SND_JACK_BTN_0,
  					    SND_JACK_BTN_0);
  		} else if (wm5100->jack_detecting) {
- 			dev_dbg(wm5100->dev, "Headphone detected\n");
- 			wm5100->jack_detecting =3D false;
- 			snd_soc_jack_report(wm5100->jack, SND_JACK_HEADPHONE,
- 					    SND_JACK_HEADPHONE);
-=20
- 			/* Increase the detection rate a bit for
- 			 * responsiveness.
- 			 */
- 			regmap_update_bits(wm5100->regmap, WM5100_MIC_DETECT_1,
- 					   WM5100_ACCDET_RATE_MASK,
- 					   7 << WM5100_ACCDET_RATE_SHIFT);
 -<<<<<<< HEAD
 -			dev_dbg(codec->dev, "Headphone detected\n");
 -			wm5100->jack_detecting =3D false;
 -			snd_soc_jack_report(wm5100->jack, SND_JACK_HEADPHONE,
 -					    SND_JACK_HEADPHONE);
 -
 -			/* Increase the detection rate a bit for
 -			 * responsiveness.
 -			 */
 -			snd_soc_update_bits(codec, WM5100_MIC_DETECT_1,
 -					    WM5100_ACCDET_RATE_MASK,
 -					    7 << WM5100_ACCDET_RATE_SHIFT);
 -=3D=3D=3D=3D=3D=3D=3D
+ 			wm5100_report_headphone(wm5100);
 ->>>>>>> for-3.4
  		}
  	}
  }

--Signature=_Fri__3_Feb_2012_12_59_02_+1100_InIqXKZOh1sZ0uby
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPKz9mAAoJEECxmPOUX5FEsdwQAJHkJ0PBxEfqMHol3ntJ5Av5
nbrf7Bcb29rtLPhRuNpplgZYlBc7pOmJl+4zczWJX9u4u86q17EjzSiZs0B7ArKo
nEbg1BCvjZDEoYd2aVSB8T3nwu/YTo7YMWRLMj66+iHcmGuhei22h9SQxa0RmH7V
tAjS4PTUhF6mtkmML05J8CYpxBgVGe4p8mFwRChHwe6qRZbpaBGqVssLWA3C2QKH
EoZH0nX2YWSThXQ1wMMca9poixCPN34MAoky/g1FSV/g7Dn5mvYkBil9gIiXzTRl
90NS4jrRcvKr7Kp7HqRzW0mjp4L4Ml/+53MUcVy/jIG/vgNgstxZ4UQGPJQkXi5D
Tt+oNczxBkGEYj2gDU7wIXZkCi00ltZaVbF72GydFvK/D6vTJgGtjYOe8SOMw8Yc
p7eedfKu5Co+TPlCKRFufTgIgXt555i/GFujQfUYsk1YaYSip0C9ULQIPl6qFFac
V7ab7ebI64vbcqWOXMmQJsKg6TysoZCSS2NLYVRIzdrZnZfMZoOCS8gmcLfxVw7b
HnM+qd5C2/DiJ6V/c3Tdc0BhgDCndEuRVQoaat5KzUtvjgSS47rHfeO3Hr3Z3bLS
WLX7CE5GEyMJhwSOo7a79yKwagPcq6pzWFKRgyS5C2uHRXCzpcC/IafoXLXTQj72
SfBoGGXYd+VDotv5pYh4
=lP19
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Feb_2012_12_59_02_+1100_InIqXKZOh1sZ0uby--
