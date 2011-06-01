Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab1FAKre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 06:47:34 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:14720 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732Ab1FAKrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 06:47:32 -0400
X-RZG-AUTH: :IWkQb0WIdvqIIwNfJfyiKBgoQwjwJ7eL6yL6M6h8JiYXs/HrEl2yUn8V3w==
X-RZG-CLASS-ID: mo05
Message-ID: <4DE618B7.5070903@samba.org>
Date: Wed, 01 Jun 2011 12:47:19 +0200
From: "Stefan (metze) Metzmacher" <metze@samba.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alexey ORISHKO <alexey.orishko@stericsson.com>
CC: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm:
 mark ncm devices as "mobile broadband devices" with FLAG_WWAN
References: <1306922913-17803-1-git-send-email-metze@samba.org> <1306922913-17803-2-git-send-email-metze@samba.org> <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E583@EXDCVYMBSTM006.EQ1STM.local>
In-Reply-To: <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E583@EXDCVYMBSTM006.EQ1STM.local>
X-Enigmail-Version: 1.1.2
OpenPGP: id=0E53083F
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig49BE8D511B2AB51562A9B33A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig49BE8D511B2AB51562A9B33A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 01.06.2011 12:20, schrieb Alexey ORISHKO:
>> -----Original Message-----
>> From: netdev-owner@vger.kernel.org [mailto:netdev-
>> owner@vger.kernel.org] On Behalf Of Stefan Metzmacher
>> Sent: Wednesday, June 01, 2011 12:09 PM
>=20
>=20
>> -	.flags =3D FLAG_POINTTOPOINT | FLAG_NO_SETINT | FLAG_MULTI_PACKET,
>> +	.flags =3D FLAG_WWAN | FLAG_NO_SETINT | FLAG_MULTI_PACKET,
>=20
> This patch will introduce incompatibility with already existing
> applications, which track usbX devices. As a result, end user
> application will stop working.

The same argument would apply to commits
e1e499eef2200c2a7120c9ebf297d48b195cf887 and
c261344d3ce3edac781f9d3c7eabe2e96d8e8fe8,
while they made it into the upstream kernel.

So I would think that such a change should be ok for a next release,
but without backport to stable branches.

> cdc_ncm driver can also be used for local link terminated in device,
> so wwan would be inappropriate name.

Would it be possible to add some autodetection for known devices,
in a similar way the cdc_ether driver does it.

It's really strange that Ericsson F3507g and Ericsson F5521gw appear as
different kind of devices, while using the same kernel version.

And Ericsson F3507g already changed from usbX to wwanX between 2.6.32
(ubuntu 10.04)
and 2.6.38 (ubuntu 11.04).

metze


--------------enig49BE8D511B2AB51562A9B33A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3mGLcACgkQm70gjA5TCD+X8wCfQje3Fe/dUh+L1jd1yimharWY
yRIAoMRkCc8JzoTJeXStAxoFWdgG+wZc
=jsFn
-----END PGP SIGNATURE-----

--------------enig49BE8D511B2AB51562A9B33A--
