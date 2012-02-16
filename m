Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab2BPBkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 20:40:25 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:32963 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab2BPBkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 20:40:22 -0500
Date: Thu, 16 Feb 2012 12:40:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the net-next tree with the wireless
 tree
Message-Id: <20120216124013.c4bf2842a3da777df184b7d9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Feb_2012_12_40_13_+1100_Dw65BnVMIAS+.=Vl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Feb_2012_12_40_13_+1100_Dw65BnVMIAS+.=Vl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
net/mac80211/sta_info.h between commit 4b5a433ae534 ("mac80211: call rate
control only after init") from the wireless tree and commit 83d5cc012441
("mac80211: station state transition error handling") from the net-next
tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/mac80211/sta_info.h
index bfed851,381de37..0000000
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@@ -52,7 -52,7 +52,8 @@@
   * @WLAN_STA_SP: Station is in a service period, so don't try to
   *	reply to other uAPSD trigger frames or PS-Poll.
   * @WLAN_STA_4ADDR_EVENT: 4-addr event was already sent for this frame.
 + * @WLAN_STA_RATE_CONTROL: rate control was initialized for this station.
+  * @WLAN_STA_INSERTED: This station is inserted into the hash table.
   */
  enum ieee80211_sta_info_flags {
  	WLAN_STA_AUTH,
@@@ -72,7 -72,7 +73,8 @@@
  	WLAN_STA_UAPSD,
  	WLAN_STA_SP,
  	WLAN_STA_4ADDR_EVENT,
 +	WLAN_STA_RATE_CONTROL,
+ 	WLAN_STA_INSERTED,
  };
 =20
  enum ieee80211_sta_state {

--Signature=_Thu__16_Feb_2012_12_40_13_+1100_Dw65BnVMIAS+.=Vl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPF59AAoJEECxmPOUX5FE2qEP/05nkhq7fD87ISOqxRC/3QYA
yWlCbdSizjPcEdTX0v6qM0xGrnxxgFHHcGmBWU9W+CFxhCnunthX/b4ruMOCN7Wf
EC/oFQ3As1FVm8qEb6lUCexD0lTh2HFsfK4ClQXhleqRuUlXj56TAlXCELqw4WfV
J0ONNjuLfg48cSmN7lRCIsame8P1BmyXT8rSAA3c4inlekv4mq+cik4g5gKNWbSX
O1QUCW4H4fIY5y5eiyWP3QJQid+YqUs7kNAToVKhdbQb0dnWTeD61t0WX4TtDXdM
gfBuUnh6SvUIpz1PSZ5Q4o8hwbPGY++7bnSLgW8gBsf7xM53pOxB2shJHZDcFwKd
cIWhE5+lTCU76vWJ9ysJS4C4QytSoF9iHOsZmIKMVUtBix5VvcNXX+bjNfgzu5rA
HLodAwt4iiqz0yFQa8yrwaPioQWRSNBrpMBQyKYIkWpW9/tX0bzrEN9kc4k1PWJe
2KKsGYANTWSHFEVcG8PL9FrWIjjEb+Y6KjgAso2oQQGDPXwGq3i8NWhiSgMWPqRs
9bGgcW4nFwnx012MrgmRFvPt+XdFA1tAhIWBQZtoO/IHarCS1Y8BOciYjkUZTGy1
BAGM7KkN8HZhuT0m9BJUsOM8vLpyQknrKA+4Ott2mkVPUOaIBKPdD8E4V4B+aszH
TDmKh25VofYUBYh0F0wv
=15RM
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Feb_2012_12_40_13_+1100_Dw65BnVMIAS+.=Vl--
