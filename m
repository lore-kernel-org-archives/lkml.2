Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2ILFiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 01:38:03 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42671 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab2ILFiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 01:38:00 -0400
Date: Wed, 12 Sep 2012 15:37:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pratyush Anand <pratyush.anand@st.com>, Felipe Balbi <balbi@ti.com>,
        Moiz Sonasath <m-sonasath@ti.com>
Subject: linux-next: manual merge of the usb tree with the usb.current tree
Message-Id: <20120912153756.1483e19457d053914f82ce28@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Sep_2012_15_37_56_+1000_5b_dz+ofHr+C5C8D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Sep_2012_15_37_56_+1000_5b_dz+ofHr+C5C8D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/dwc3/gadget.c between commit f4a53c55117b ("usb: dwc3:
gadget: fix pending isoc handling") from the usb.current tree and commit
348e026fafe2 ("usb: dwc3: gadget: Fix sparse warnings") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/dwc3/gadget.c
index c2813c2b,ba444e7..0000000
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@@ -1091,26 -1078,10 +1082,21 @@@ static int __dwc3_gadget_ep_queue(struc
  	 *
  	 */
  	if (dep->flags & DWC3_EP_PENDING_REQUEST) {
- 		int	ret;
-=20
 +		/*
 +		 * If xfernotready is already elapsed and it is a case
 +		 * of isoc transfer, then issue END TRANSFER, so that
 +		 * you can receive xfernotready again and can have
 +		 * notion of current microframe.
 +		 */
 +		if (usb_endpoint_xfer_isoc(dep->endpoint.desc)) {
 +			dwc3_stop_active_transfer(dwc, dep->number);
 +			return 0;
 +		}
 +
  		ret =3D __dwc3_gadget_kick_transfer(dep, 0, true);
- 		if (ret && ret !=3D -EBUSY) {
- 			struct dwc3	*dwc =3D dep->dwc;
-=20
+ 		if (ret && ret !=3D -EBUSY)
  			dev_dbg(dwc->dev, "%s: failed to kick transfers\n",
  					dep->name);
- 		}
  	}
 =20
  	/*

--Signature=_Wed__12_Sep_2012_15_37_56_+1000_5b_dz+ofHr+C5C8D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUB+0AAoJEECxmPOUX5FEsf4P/1bhKq9xh1knzlkia0GclQuj
h5w41Z5nOUGv1NKLZ0QwvebOEDoQtthzcqY3hrqscJpgwB3Bc1dbxJYoSCsWBHXJ
I1FYexhQ8ezUo0rutCA41ZISe2wencDnPzGyRKdDkO16kaYZD1RvpNUxidwDR9/4
VBJuJ+hu6e/GM6iUiFbOuvbRSiq+fsX93G/I+RaKYxXZHdaMrseSzjoO5bc8pBed
sEJJHJ8ZK/YvfLyqYCIvC0nBwfdR0Z6mfNxhnUUaCE1JsRAUabHMkd/cHnwf/0c8
2VdpFqFYl+VvDIx3I3p5IYzypR+n677rSqdCM20Wx+hQUbgHE30lOAKNe8ykkevl
kcs9BE38BMqtzJIN7zlLOrDKxMBUIIV2lOJnIAdR2DXq4KuGvsVmcs9GN5D6NP9V
8QZg1T7I2Xkm3fFz9VxwnFgpVzUkLfZ/LylVrJ7XAojy0QHQ+96j4qqdscjLEfh7
k4+9uwJpUbX9qYFV6LpyTyWoAHY2x2/cy75mu90jxnRGZUKjOWjIpenrLy6863bR
WOWwJnsdmv9EsUQRqq0vR5Vg/OB3dqFMzZkYbhFoepQFKCoAkjrjk3HkOmHhP844
b1CK40YYNw7HEpJ17angx5hYNbbH2FjOqsep+1LxVaMTQWCRGiOjyhQi/s+vgc8L
j19TVaCKVXfGTL7OMgav
=1OVv
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Sep_2012_15_37_56_+1000_5b_dz+ofHr+C5C8D--
