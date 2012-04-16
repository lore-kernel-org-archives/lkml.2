Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab2DPCto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 22:49:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47764 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab2DPCtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 22:49:05 -0400
Date: Mon, 16 Apr 2012 12:49:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: linux-next: manual merge of the wireless-next tree with the
 net-next tree
Message-Id: <20120416124902.26193e1af5e5177cc91f5df8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Apr_2012_12_49_02_+1000_mORNir.QguHQWEFy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Apr_2012_12_49_02_+1000_mORNir.QguHQWEFy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
net/wireless/nl80211.c between commit 9360ffd18597 ("wireless: Stop using
NLA_PUT*()") from the net-next tree and commit d91df0e3a1b9 ("cfg80211:
Add channel information to NL80211_CMD_GET_INTERFACE") from the
wireless-next tree.

I applied this merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 16 Apr 2012 12:45:25 +1000
Subject: [PATCH] cfg80211: fix up for NLA_PUT_ api changes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/wireless/nl80211.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b33a852..acae9d4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1546,10 +1546,11 @@ static int nl80211_send_iface(struct sk_buff *msg, =
u32 pid, u32 seq, int flags,
=20
 		chan =3D rdev->ops->get_channel(&rdev->wiphy, &channel_type);
 		if (chan) {
-			NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ,
-				    chan->center_freq);
-			NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
-				    channel_type);
+			if (nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
+					chan->center_freq) ||
+			    nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
+					channel_type))
+				goto nla_put_failure;
 		}
 	}
=20
--=20
1.7.10.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__16_Apr_2012_12_49_02_+1000_mORNir.QguHQWEFy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPi4ifAAoJEECxmPOUX5FEJhkP+wSxkq18uYZvv/woS44gntNR
ZcFKIA4IQerY5nNMizc9Hfbo5/Q873cskt7E2MyB8qA/51BsmK1arllspe0vr2Is
usTMIu4xfujUvuZbMiWz7NUdxe4HbmeDjFCJMpBoL8Oh3sKLEO1rZb+zzmcIT/Kj
ALbJHZYeL+rm+BgHO1gDwOi7Fkcsw36pWWqqDtQw/TnpoEP9OiliQ3fo3tbH2gvi
BJdMBOTHU4ZvqxAdiF+AL9AD3hqcmTLXBLMi941HBpGMzVX4SkR1l6prcM3SoK2h
BafX6ksym3ConNbBFiK6fo/b8edixRHd44UWxycxo6g3VkBcNQTBll309el+SacQ
t2Fl5PEVzj/868DYi32wfISf/UpkSQL/rLH9bngSj0uQILkMdyTzefOwKShPwmvS
ouSNOIc43mmRRElEAF+NLNLoXk836tfvJVTpGcy7zMpWa8E53ZdExXKdCJKwDd46
hWViXRz/5Ej8ZI6sjPej+eOjywzZoda8sCGfSSj2Ud6IEAqJl8CD4i7ExqXcgfD8
1K3Fak4/U8fpWSBkW8pveIrsamK8Ek02Qvp6Paa0CxYfORtcEuog3yl9om5jCIgQ
NQDqRC4wdPgKjQzRea5vrOnKnijOUsTtdqL0mkU6jUGLEMaqKXpkRbW0B2oWX7qb
rq0yOZogsaTNh0VQNvMF
=JyhH
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Apr_2012_12_49_02_+1000_mORNir.QguHQWEFy--
