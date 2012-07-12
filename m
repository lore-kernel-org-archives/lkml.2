Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030729Ab2GLTG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 15:06:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833Ab2GLTG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 15:06:56 -0400
Message-ID: <4FFF2040.1010008@redhat.com>
Date: Thu, 12 Jul 2012 15:06:40 -0400
From: Doug Ledford <dledford@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@canonical.com>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC, PATCH] CLONE_NEWIPC and exit_group()
References: <20120626120425.GA10275@otc-wbsnb-06> <20120710085034.GA24645@otc-wbsnb-06> <20120711152422.a1f07bd5.akpm@linux-foundation.org> <20120712150702.GA1897@otc-wbsnb-06> <20120712185452.GA24342@sergelap>
In-Reply-To: <20120712185452.GA24342@sergelap>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6FE79A0C9E64D873E11802DE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6FE79A0C9E64D873E11802DE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/12/2012 02:54 PM, Serge Hallyn wrote:
> Quoting Kirill A. Shutemov (kirill.shutemov@linux.intel.com):
>> On Wed, Jul 11, 2012 at 03:24:22PM -0700, Andrew Morton wrote:
>>> Am I reading that right?  1000 forks take 33 seconds, with basically
>>> all of it just sitting there asleep?  This look quite terrible - what=

>>> causes this?
>>
>> It seems free_nsproxy() + synchronize_rcu() are too heavy to be in
>> exit_group() path. Patch below helps: 8s -> ~0.5s for me.
>=20
> And sys time goes down by that much too, or only user time?
>=20
> Given that, with user namespaces, it'll soon be possible for users who
> are unprivileged toward the host to be able to create and destroy
> namespaces, if the patch ends up making it easy for a user to consume a=

> bunch of system time and not have it accounted at all to himself, then
> I think we should keep it as is.

Indeed.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford





--------------enig6FE79A0C9E64D873E11802DE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJP/yBAAAoJELgmozMOVy/d+XoP/3s2osV01JRBMukKgez1kxMo
TJLxUeODIdFwsr2CzBGSgsRz8ycREBUJmr/9jSvX5YYFz2begvUOGR+qVOiQ4aSP
O3c1hpIz4fVUHFRpE0xu61TBU35ULnnJYBtqcPgYVZYw4p1qFNXpBRddQxPrIxh7
pRiXOyODOkVZQuKKsL0/cIDHHdtwIQL47WsUPMe62mMf8srzLukcO4+AXi+vHLah
Uoi0FC664xYdNy22w9y96s0T6Zw1ADFAYaGhU9YDPSOrg9/L4DeTTtWT/MS5yy/K
erM9hkioy42NbnoZX58O6LZOVMLTeEp6SEbPW+yvdzxQpC7UZXRLNIEN4tzK+gIY
WmPbAmtOnLqipyMqkr/54iGYhWdRQMyv3yOvHvaVOpiyWd7xlgV6KmlDIe3Jsr+E
ql0nB6y7CK6LkRwMqw7prC9YUFo+INNcmsoODaqxMHgTkteTKHckBNj64Wg5dmPy
/9Hb2uiQwpn7G1nvM4N2RTZdH5WgpVzzkjSUGfPQgAfXxLDRghDPnxLzBJa/qIL/
YqZqanPquagjsEptyug1l9C5+hzUIS5ITzJy0oIjTeJ3gIo4Hre3CE2mUjB0hSB4
yY8zRgIMcyUdsziIfHHiA9vFmuvV2FhnV7ExOOkpPuoq6E+KY4nHnjyGHxLXP64T
+CbXyZzepkPEKVUP8sCi
=gRR7
-----END PGP SIGNATURE-----

--------------enig6FE79A0C9E64D873E11802DE--
