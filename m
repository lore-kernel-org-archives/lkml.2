Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab2GCEJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 00:09:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53327 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab2GCEJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 00:09:47 -0400
Date: Tue, 3 Jul 2012 14:09:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russ Dill <Russ.Dill@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the usb tree with the mfd tree
Message-Id: <20120703140938.b2ae0cf0ce2a3a470bb6cec6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jul_2012_14_09_38_+1000_TFRfmXuKPAQ.dnHj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jul_2012_14_09_38_+1000_TFRfmXuKPAQ.dnHj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/host/ehci-omap.c between commit 996439f8fa07 ("mfd: USB: Fix
the omap-usb EHCI ULPI PHY reset fix issues") from the mfd tree and
commit 984e97483a14 ("ARM: OMAP: USB: Fixup ehci_hcd_omap_probe error
path") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/host/ehci-omap.c
index c304354,6e15fc8..0000000
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@@ -329,11 -330,6 +329,11 @@@ static int ehci_hcd_omap_probe(struct p
  	omap_ehci->hcs_params =3D readl(&omap_ehci->caps->hcs_params);
 =20
  	ehci_reset(omap_ehci);
 +	ret =3D usb_add_hcd(hcd, irq, IRQF_SHARED);
 +	if (ret) {
 +		dev_err(dev, "failed to add hcd with err %d\n", ret);
- 		goto err_add_hcd;
++		goto err_pm_runtime;
 +	}
 =20
  	if (pdata->phy_reset) {
  		/* Hold the PHY in RESET for enough time till

--Signature=_Tue__3_Jul_2012_14_09_38_+1000_TFRfmXuKPAQ.dnHj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8nCCAAoJEECxmPOUX5FEIjkP/2W3sgy5Z56tLuOWTxFq+1ec
k2JeDocO15XMrCt6kpIFeDTjgTGvaPBDFb8uXKBvncbG3FcwvGUlJ1i0ex0SX70t
4wJxfFJyzsiNzqRmHJZkQUuHSWLtaXpLDb5fTk6Y9AEKRhvYYhg/ZaBzgHvaVRe7
Q6r4tmEi9HvDHU0mlQy9PQZZ34kgFTP8cwr/xHEU0Ru7OYe3TQaFVqyjWQYyUfVQ
KpTCFuKKMi92ojo67C4/7j/47yBnDCAEW4DKhiRvRR7Nl7NeWwzkoAGLN4LhH8GT
r/z5TIFpbZC2fBKejsEH2dvECXEhMhYmYd/5KxS5d//mzBGzq4wUhXOq5jMDXKA6
nqfNnHfpXhNbX2sF78Z60fmVVAvXlnlVHWhnjoKedm0nmmrQioTfnnfbEffVdVqL
F6TWm1MGNe22/iTY70tjORbKjm9lo23S0jQZ9NM74LQOfJACLuDaXDISDgoQPCVd
qiTHlqo1FoG5IwKohO5WB/HGohv5zmGlykUiHaPZOs8qKZT2thQ9LbWA5V2eqnQ6
q9i20mGOj1NqseTa+Q12Dn0aTkddjzoY5CpouZEDvo93onOkvH25I+OkRUV/8uTj
t0WXkJFIIfLbksJQSlKC3mFu6WnU/Ygj+1fBk+4zC0G7H7lZsE9JeUso8syOAApq
4lKyLRgjwxLuspSLAOJp
=Ayzz
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jul_2012_14_09_38_+1000_TFRfmXuKPAQ.dnHj--
