Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab2K0Ouy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:50:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753233Ab2K0Oux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:50:53 -0500
Message-ID: <1354027837.4266.52.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 1/3] tools/hv: Fix for long file names from readdir
From: Ben Hutchings <ben@decadent.org.uk>
To: Tomas Hozza <thozza@redhat.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, kys@microsoft.com
Date: Tue, 27 Nov 2012 14:50:37 +0000
In-Reply-To: <1354002994-2094-1-git-send-email-thozza@redhat.com>
References: <426367E2313C2449837CD2DE46E7EAF930E5A96D@SN2PRD0310MB382.namprd03.prod.outlook.com>
	 <1354002994-2094-1-git-send-email-thozza@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rBgYmNah1Pe1eyl/RaNz"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rBgYmNah1Pe1eyl/RaNz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-11-27 at 08:56 +0100, Tomas Hozza wrote:
> kvp_get_if_name and kvp_mac_to_if_name copy strings into statically
> sized buffers which could be too small to store really long names.
>
> Buffer sizes have been changed to PATH_MAX, include "limits.h" where
> PATH_MAX is defined was added and length checks ware added via snprintf.
[...]

PATH_MAX has nothing to do with any actual kernel limit; it's no more
meaningful than the current value of 256.  Network interface names are
limited to 15 characters, thus the current array is more than long
enough.  So I think this is entirely unnecessary.

Using snprintf() is a good idea, but you need to check the return value
and handle the truncation case somehow.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-rBgYmNah1Pe1eyl/RaNz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULTTPee/yOyVhhEJAQpF/w//bZ7Adj4F4j/1HaW1XMzHnUXZcjGkfUZT
MoLSPG7JknIJjUJPtsR3KNX7mruXTMINRWLlAOQ1jxgzgW+PIc6ko0QoTAifef7d
TVUDMgOGj2CwargTvlrCh8lpGWJJRijidScPwD0pgPcPVEK8cho3IxG9ETk/cumE
IOuKSY8QztoDujZATLpMUEEbvkZYDJTlnJXDvX6jtW8dAyVcQUFl59sDtjQJve3b
V5PW8gwtGIwDBn0AEoyQrEmxcIKJyapHVlxJzj1yjonqEbQeF7uEQZqjnu6OvqbR
doZN1viJsFyPLwZAQrmzx7VaQYf5gzL9APTZrloGhyieFIFsrRfNtqxHgJQWsE8h
PXM7H8Cft30UM0v9CbDL9yXgO7yaSu2r6ZOy60RHZCsgWfIoyp/1APszZWdpunTn
5ukQUUUVZbE2s2tfCmjvW898FNtZz1pvS3wIHZSKSiLrOgx1UPdHJXHnL3YlwtH+
9NEDon5ljGQpCP2xmPz+KiWwZqiKCKuApRv/wvGQQRaAb32FTiB6d2pOl0R+Cofw
+Xw3uA4hXHO58J86tPm5yZHW0S5tA84Xor8kDHhX9t4o0AGPHYPLgJagGRH7WvVP
QrRZrfAjT0p6AMiFA779kZkqwxmgZMXrZxxfIgMG+ulW4zLDwlDWnuTkrtBrujbY
roM+phAyd9U=
=dwJd
-----END PGP SIGNATURE-----

--=-rBgYmNah1Pe1eyl/RaNz--
