Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab2JVANr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 20:13:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38787 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab2JVANp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 20:13:45 -0400
Date: Mon, 22 Oct 2012 11:13:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Franky Lin <frankyl@broadcom.com>
Subject: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-Id: <20121022111337.596cad53ab4a77dfe0dd8965@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__22_Oct_2012_11_13_37_+1100_VWZt_zM3fN1Fmx.k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Oct_2012_11_13_37_+1100_VWZt_zM3fN1Fmx.k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c between commit
3e4f319dacc6 ("brcmfmac: fix end of loop check (signedness bug)") from
the wireless tree and commit 81118d165811 ("brcmfmac: Using zero instead
of NULL") from the wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 411dfe7,b27e245..0000000
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@@ -3972,8 -3972,8 +3972,8 @@@ brcmf_set_management_ie(struct brcmf_cf
  	u8  *iovar_ie_buf;
  	u8  *curr_ie_buf;
  	u8  *mgmt_ie_buf =3D NULL;
 -	u32 mgmt_ie_buf_len;
 +	int mgmt_ie_buf_len;
- 	u32 *mgmt_ie_len =3D 0;
+ 	u32 *mgmt_ie_len;
  	u32 del_add_ie_buf_len =3D 0;
  	u32 total_ie_buf_len =3D 0;
  	u32 parsed_ie_buf_len =3D 0;

--Signature=_Mon__22_Oct_2012_11_13_37_+1100_VWZt_zM3fN1Fmx.k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQhI+xAAoJEECxmPOUX5FEk2kQAI/th7O0QlFcq3sRHxaWh6t3
29O1HTPwutGHIl42CzVCYzzwPd4VJn98pNmJAeoBcXfIKRFlTVKSPQEvb+n+V5uo
HuzHmBlGD152EQ/Mfrf3k5jqUJ72elntavBTJCKHugeDuRQ8qum4ujpmNys1rGwN
9BAmJkhI6mqU7vFXENnNtM14c8fYl8HbQQCUep6N1Dboj1ZNlhXnPPMkmqohvqwn
nEMzW4bHGchehcYuYdJ7ouAZ6kCXzYIisrQRScLfNtZRmE44AIgcehLoXvglq6Iw
LQaD1/Zzwm4XlJrJotgvKBRuBUIcyGcFZ8e9e+GvL13JwbxyltHbk6HvJWjNyKBh
A5sdCF2bzdW7qq3hTStGiY1Urykchr2aUIGUrsgyR3dWRnHTt66q55mHi5ePqZ85
ot1GPlpQseV5DoQP2RyJ8p/+bkI3G5iV+szyyOGgPTtO9EkyM5tBhELDEO2wUZ0p
ucORGCJPc49oV4oXs1xIgyVF7lZ8SkmnqejU3w7ohG8mzkEQBHox7BeeADXcVxd1
WXcc6cYOWeer93LWLkZ3Zv9LGEuNg6sODBfQwIudGevykF41pFiZXeRbLNPALZlf
Vx5CQqgwc5PTq6UUUMMhpCsXC5P3E831fEKIS3Eeh1BnO8x3Nff/Q73MKgdIldSR
UQRFhMB/bvaKacio8n1U
=7691
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Oct_2012_11_13_37_+1100_VWZt_zM3fN1Fmx.k--
