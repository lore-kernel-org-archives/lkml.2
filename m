Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab1LQEav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 23:30:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37605 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177Ab1LQEap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 23:30:45 -0500
Message-ID: <1324096239.2825.313.camel@deadeye>
Subject: [PATCH linux-firmware 3/4] keyspan_pda: Fix parse error with as31
 version 2.3.1
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Date: Sat, 17 Dec 2011 04:30:39 +0000
In-Reply-To: <1324096119.2825.310.camel@deadeye>
References: <1324096119.2825.310.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-OzUwxIyXM4q+PxkoLpHV"
X-Mailer: Evolution 3.2.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OzUwxIyXM4q+PxkoLpHV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

keyspan_pda.S has an out-of-range decimal constant that looks
like it was really meant to be a binary constant.  Comparing
with the binary, it appears that as31 used to treat this as 0,
so change the source to use 0 and add a comment on this.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 keyspan_pda/keyspan_pda.S |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/keyspan_pda/keyspan_pda.S b/keyspan_pda/keyspan_pda.S
index 418fe69..602bcce 100644
--- a/keyspan_pda/keyspan_pda.S
+++ b/keyspan_pda/keyspan_pda.S
@@ -285,7 +285,12 @@ clear_rx_ring_loop:
 	mov dptr,OUTC
 	movx @dptr, a
 	;; setup the serial port. 9600 8N1.
-	mov a,#01010011		; mode 1, enable rx, clear int
+	;; Original source had:
+	;;mov a,#01010011		; mode 1, enable rx, clear int
+	;; This was presumably meant to be a binary constant, but it's
+	;; really decimal and out of 8-bit range.  as31 used to treat
+	;; it as 0 and that seems to have worked, so carry on with 0.
+	mov a,#0
 	mov SCON, a
 	;;  using timer2, in 16-bit baud-rate-generator mode
 	;;   (xtal 12MHz, internal fosc 24MHz)
--=20
1.7.7.3




--=-OzUwxIyXM4q+PxkoLpHV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATuwa7+e/yOyVhhEJAQrMWhAAusGTRShUn9bnSutElAeJi0ycAXJWlQEK
DUGoLiBsJdW154iSTglLRlfq6ADD5qSWMFkMMW6r2J7K5tYdnqiLCOvmCNLZkBjg
Y+CrC8k+jns1BJHdxr8LyIkxbKjoB0d8ObYgM9Pf37MFWs/oX578ZVU/XIai7R0I
+zzJaJ0dw297i7p1jSh746UI6pGW3/NkJfHeffY4Jp+quVQsDMRYChkwMrJsswcv
We42LOYCb5FXDChfxvpICAfclv3iTr+YiywymBn1LuYrrhHW1ISo1YIsftMdYTDi
rGgvAVvzE4PO2vPV2soRMMmnoTjuDpZkG2tWiHvWAoRXuNnzoRh7oHBiWKUi5fex
0AjEfAPSoDJdq1TxBvtrBAHDac0Y3PUwVO1YBuGKikp/RJsGF2sWeSxE8k7YwLZd
zkjuEv4ZVsT+tMlV4m27Wg8nZRI3CYz3IlzeSPSLEBjlpfdTDsyWEG11tCh8VDS/
a4Z7haeptRzQyr3tymXwnEoY69qKdISVxbbMJ4LTcVFvd32gVFyOTElmZHBvGUt4
0gzaJpiZ5W5Duuz+Cwbokcfz8L+mJbQx3YPbdve/NIh8tzy8MofushJsdKBTg+f3
4LE7mhAn0QLQ7ekkC5uGx9OVu/nhefzaiQllfbLZg6TJb/tEXfj3om2XyWYdvQZB
TZuBG2Y0ock=
=IyPh
-----END PGP SIGNATURE-----

--=-OzUwxIyXM4q+PxkoLpHV--
