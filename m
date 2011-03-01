Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1CACOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 21:14:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38875 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754471Ab1CACOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 21:14:48 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Milton Miller <miltonm@bga.com>,
        "David S. Miller" <davem@davemloft.net>,
        Anton Blanchard <anton@samba.org>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
In-Reply-To: <20110228162407.878045010@clark.kroah.org>
References: <20110228162407.878045010@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-VeW8RvTDGl/eTup/Gd+e"
Date: Tue, 01 Mar 2011 02:14:33 +0000
Message-ID: <1298945674.3069.188.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [22/68] ixgbe: prevent speculative processing
 of descriptors before ready
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VeW8RvTDGl/eTup/Gd+e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-02-28 at 08:22 -0800, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let u=
s know.
>=20
> ------------------
>=20
> From: Milton Miller <miltonm@bga.com>
>=20
> commit 3c945e5b3719bcc18c6ddd31bbcae8ef94f3d19a upstream.
>=20
> The PowerPC architecture does not require loads to independent bytes to b=
e
> ordered without adding an explicit barrier.
>=20
> In ixgbe_clean_rx_irq we load the status bit then load the packet data.
> With packet split disabled if these loads go out of order we get a
> stale packet, but we will notice the bad sequence numbers and drop it.
>=20
> The problem occurs with packet split enabled where the TCP/IP header and =
data
> are in different descriptors. If the reads go out of order we may have da=
ta
> that doesn't match the TCP/IP header. Since we use hardware checksumming =
this
> bad data is never verified and it makes it all the way to the application=
.
[...]

Packet splitting should be completely disabled on the 82599, anyway.
Greg, what happened to this patch:

commit a124339ad28389093ed15eca990d39c51c5736cc
Author: Don Skidmore <donald.c.skidmore@intel.com>
Date:   Tue Jan 18 22:53:47 2011 +0000

    ixgbe: fix for 82599 erratum on Header Splitting
   =20
    We have found a hardware erratum on 82599 hardware that can lead to
    unpredictable behavior when Header Splitting mode is enabled.  So
    we are no longer enabling this feature on affected hardware.
   =20
    Please see the 82599 Specification Update for more information.
   =20
    CC: stable@kernel.org
    Signed-off-by: Don Skidmore <donald.c.skidmore@intel.com>
    Tested-by: Stephen Ko <stephen.s.ko@intel.com>
    Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-VeW8RvTDGl/eTup/Gd+e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATWxWg+e/yOyVhhEJAQrdJBAAwKVvhSM6QiiHyb14flZ+FVSGSyUTztsP
yZrLl7oiLnVzPUhjguvpRECFYlRWMj++vqxF02GB+ge5YXn4+Sy2ZKSaIa84mNQl
4LGjOhj3Npzl68V/vqB9TU/TFFEjmD8jH9cX6YrWDxfJyUzctyREEZ2T+QeL5yK8
wmBwxpdV103BlXaggXCuCQ+AN/nyVgZ+7RppHTxCI9IdHz/PbiZKUqkNHH5OlDRs
AWMAHohOn13RK5hJed0JF1koXMB/EX1yfJMiZ5EM3llNjC+ESWbEkRKbRcvJR2lO
fgS33GpkPjmYTbfHqPbBNalfDcMoa+MvHJ1v0DVy1tTxnVn3l4rp9vSRpXu2MJVH
AFP8nHLK8iqfR37ZHzGCCD4Zt6EMMCPfCs2qlVxyPVLT4owTrhFR/42FqjTpMGyH
Befm5bYQpTGJAUISIqmmbSwwg44y84E6MSty0OXBdxaWD8SHaAt93gYURQHOz7wd
hIfSHBHv/eVk5SkmT5xU6jSEJlPfZ23RJybMbWWxgzn0qL9KbV+XLGVAb6WxHMrB
p39dVV165RVs31Bk+xggd5jdnoAyafkK+1CevZPZw32i34Om6GsfeblnSq8At9NM
tyA9CNq+7mk+zUv+sNuNyIt1gudoFi4rfp/Ijd9fKASrt94jJiHjLXA2+4Xe39CB
4pGLggEdBtA=
=sB8s
-----END PGP SIGNATURE-----

--=-VeW8RvTDGl/eTup/Gd+e--
