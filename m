Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2F1OfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 10:35:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:36998 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab2F1OfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 10:35:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="186119027"
Message-ID: <1340894351.3070.121.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: add minimal amount of reserved erase blocks in
 Kconfig
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 28 Jun 2012 17:39:11 +0300
In-Reply-To: <1340636918-7505-1-git-send-email-richard.genoud@gmail.com>
References: <1340636918-7505-1-git-send-email-richard.genoud@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Kh5GMS5+Pshs3Z7iwPmc"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Kh5GMS5+Pshs3Z7iwPmc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, first of all, this 1% is does is not good enough for modern devices.
It is just a default I picked out of the thin air.

What we really need is to make it possible to specify beb_rsvd_level at
attach time. I believe it is not difficult to implement:

1. Add a parameter to ubiattach
2. Extend the attach ioctl and add beb_rsvd_level there. We have 12
unused bytes in 'struct ubi_attach_req'.
3. Extend the "mtd" module parameter and allow to specify beb_rsvd_level
there as well.

That's it - you can specify the needed numbers for your flash.

 to make this per-MTD device
On Mon, 2012-06-25 at 17:08 +0200, Richard Genoud wrote:
> The problem with this behaviour is that NAND flash manufacturers give a
> minimum number of valid block (NVB) during the endurance life of the
> device.
> E.G.:
> Parameter             Symbol    Min    Max    Unit      Notes
> --------------------------------------------------------------
> Valid block number     NVB     1004    1024   Blocks     1
> Note:
> 1. Invalid blocks are block that contain one or more bad bits beyond
> ECC. The device may contain bad blocks upon shipment. Additional bad
> blocks may develop over time; however, the total number of available
> blocks will not drop below NVB during the endurance life of the device.

OK, in this discussion is is easier to talk about maximum bad blocks
(MBB) rather than minimum good blocks, though. So basically, the vendor
guarantees that there will be at most MBB bad blocks.

> From this number we can deduce the maximum number of bad PEB that a
> device will contain during its endurance life :
> A 128MiB NAND flash (1024 PEB) will not have less than 20 bad blocks
> during the flash endurance life.

OK.

> BUT, the manufacturer doesn't tell where those bad block will appear. He
> doesn't say either if they will be equally disposed on the whole device
> (and I'm pretty sure they won't).

Right, then if you implement what I suggested, you'll pass
"beb_rsvd_level=3D20" when attaching both partitions.

> So, according to the datasheets, we should reserve the maximum number of
> bad PEB for each UBI volume.
> (Worst case scenario: 20 bad blocks appears on the smallest UBI volume.)

Err, not smallest UBI volume, but smallest MTD partition. We reserve
PEBs per-MTD device.

> =3D> The actual parameter MTD_UBI_BEB_RESERVE is not enough to cover this
> scenario. We need to set a minimal number of reserved PEB for a UBI
> volume.

Frankly, I do not understand this logic :-) And your patch looks wrong -
it touches the "auto-format" code which you may consider more like a
"debugging" feature and should not rely on this in production.

--=20
Best Regards,
Artem Bityutskiy

--=-Kh5GMS5+Pshs3Z7iwPmc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7GyPAAoJECmIfjd9wqK06zAQAMQu3/jNciBTz8xUbwIGgpw6
n34b4fK2BhZXwVHyf98Op1mcaqsraiEbCkSL7/b2u+CUYSvPc6H0Fk95z8n643TZ
9MYVgOJ1P5cLp0awrm3on+yv98QyYyL1i4k7dvXlLber+Js36/qsDyNYWVWWhI3a
yQolfZOS+fTKx/XNls7IYExNmLfcdPuCAJuvbfiaxeRgWd0VWDuagugEQGnMGvXO
suttqZeaaHYcIWtiI8D3Wbhe6a4D42hJlGINtyP+BDWl9TjLwDa/2f+TBXNLYgRk
RA19Fw5jl1hcCLQZhM0XNqtzCebCBn7mF/K3zQAigS2YPQCCiD64baRIXY9Jzusq
PWqOtvhXkDroHBOGxCNTO9wIXMTqQfmS0wzJocseqXVz8dBHr82ziolfj0cnBd6r
zER+mXcQXDY0hd+YLexFI7h4ISNyY5XVXRnPtHYjm8VHkmL0yUshO7N9VcZhxH/b
HEB4eOXpfz4HWohLcKxm1quY73XRE8D6rWqg6eIAgzJJAt1nCr3yDyMav94O/n12
aB2rNMyygoDD4Ed2khr4n+Tt3EkOUH9IaM5j4bKwP5Gs/CDvp/F1d4gTQ5yKc4u/
NHyJC1YHyC2uEwJvNJEziBX/1fb6/vNS/Bl4QNidIvd5SLS9u2CROEfVJ3L9C61J
wmPvXe2+R4crV6USge5k
=qm9b
-----END PGP SIGNATURE-----

--=-Kh5GMS5+Pshs3Z7iwPmc--

