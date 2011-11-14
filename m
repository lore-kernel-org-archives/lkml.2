Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1KNAx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:53:56 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:48629 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1KNAxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:53:55 -0500
Date: Mon, 14 Nov 2011 11:53:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Miao <realmz6@gmail.com>
Subject: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-Id: <20111114115346.5638260db4dda17e244e6eb3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_Nov_2011_11_53_46_+1100_8HVn3nrA3.cKYAqt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Nov_2011_11_53_46_+1100_8HVn3nrA3.cKYAqt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
drivers/net/wireless/libertas/cfg.c between commit d929bbc63069
("wireless: libertas: fix unaligned le64 accesses") from the wireless
tree and commit 731f8e1c41a4 ("libertas: release bss references and avoid
warning from cfg80211_inform_bss") from the wireless-next tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/libertas/cfg.c
index a7f1ab2,89f34ad..0000000
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@@ -632,9 -633,9 +633,9 @@@ static int lbs_ret_scan(struct lbs_priv
  				     LBS_SCAN_RSSI_TO_MBM(rssi)/100);
 =20
  			if (channel &&
- 			    !(channel->flags & IEEE80211_CHAN_DISABLED))
- 				cfg80211_inform_bss(wiphy, channel,
+ 			    !(channel->flags & IEEE80211_CHAN_DISABLED)) {
+ 				bss =3D cfg80211_inform_bss(wiphy, channel,
 -					bssid, le64_to_cpu(*(__le64 *)tsfdesc),
 +					bssid, get_unaligned_le64(tsfdesc),
  					capa, intvl, ie, ielen,
  					LBS_SCAN_RSSI_TO_MBM(rssi),
  					GFP_KERNEL);

--Signature=_Mon__14_Nov_2011_11_53_46_+1100_8HVn3nrA3.cKYAqt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOwGaaAAoJEECxmPOUX5FEvJwP/jvNjQbPtKMerTNpGeNEOR2F
Hg5rUx/3LkRBhEc36MaOcrn+42KfdnTwxtdAsGab8VDOw0gureZVbOPruj4LEFI0
Lmu58jYb0EXVqxaUtI+0gZVSYGRK+KKo73jZ+DX/q+P1KICH1eA7Arp+pwgSXR7v
ec86QXoznpuDBXS9LAOjezmN2wedLheA8EfzfMZ4lDCMXNUYslV+Uor59N5NgOJH
BrEIxJ9oDD1/y227if2Dv5X7vNQwHtaCuBSKYDBlVQJL3Pr0tsl5oZIF3dYGH+KO
SkcrmcqxXqACtP6zqDM07WeEHsixvCvgPzieHjxwlIJQAZ+bShU8fvn4FGWO4KvG
mUdPijP0QG2JKhVLpbQHImztgw9OtOjus9tPMtR9VgsiPfw0AY20FqPMQV2obIy7
oqj7inJjmzQGX9Ik09vQjmnl9L1ivRmuDXyozKqOvP4ZtjEK87tDl9qWtxJtptkG
NhClGTJV5rskFst5Q+3Lwu0NN4YDW8jfZ2vTobC3A4QN1ethOYcVz0X9oDo3kGzO
p/KYEz9mYfH5O81CVyzxpJFksOmYHd16ak5Vk68urvv9us4CjHxGEinh3/TSgJRU
iadRt+LhewfSDs+dkDgKIgATKZ2bkXnkvMjJ2TtaV87o8S+eopHDBJtL1b3MMDbM
kfCdml+7scIon4oZ2d3D
=8Q0f
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Nov_2011_11_53_46_+1100_8HVn3nrA3.cKYAqt--
