Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966466Ab2EOTE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:04:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966394Ab2EOTE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:04:26 -0400
Date: Tue, 15 May 2012 14:04:13 -0500
From: Clark Williams <williams@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] compile fix for brcm80211 on v3.2.17
Message-ID: <20120515140413.04c19fad@redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OtPXcnm=hvV_02p2QT8jnsf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/OtPXcnm=hvV_02p2QT8jnsf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Ben,

Found this while building v3.2.17-rt28:

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/w=
ireless/brcm80211/brcmsmac/main.c
index f98becc..833cbef 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7879,7 +7879,7 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11r=
xhdr *rxh,
        if (wlc->hw->suspended_fifos) {
                hdr =3D (struct ieee80211_hdr *)p->data;
                if (ieee80211_is_beacon(hdr->frame_control))
-                       brcms_b_mute(wlc->hw, false);
+                       brcms_b_mute(wlc->hw, false, 0);
        }
=20
        memcpy(IEEE80211_SKB_RXCB(p), &rx_status, sizeof(rx_status));

Not sure if that's completely correct but I found another call site for
brcms_b_mute() that also passed 0 flags.=20

Clark

--Sig_/OtPXcnm=hvV_02p2QT8jnsf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk+yqK0ACgkQHyuj/+TTEp1zwACfed7XsLddK2dD+K495IiUfMkG
0pgAoK9X2ziojlgJxDMkUhMlQKMH11id
=A1lT
-----END PGP SIGNATURE-----

--Sig_/OtPXcnm=hvV_02p2QT8jnsf--
