Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab2ICMks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 08:40:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44887 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab2ICMkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 08:40:47 -0400
Message-ID: <5044A547.2010603@pengutronix.de>
Date: Mon, 03 Sep 2012 14:40:39 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@gmail.com>
CC: linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v6] can: add tx/rx LED trigger support
References: <50191EA5.1040303@pengutronix.de> <1343845298-2065-1-git-send-email-fabio.baltieri@gmail.com> <20120824051016.GB1718@vandijck-laurijssen.be> <50376550.4020501@pengutronix.de> <20120824124248.GA422@vandijck-laurijssen.be> <20120824220142.GA1470@gmail.com>
In-Reply-To: <20120824220142.GA1470@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9D8A217EF256FB81A0C34C77"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9D8A217EF256FB81A0C34C77
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/25/2012 12:01 AM, Fabio Baltieri wrote:
> Hello Kurt,
>=20
> On Fri, Aug 24, 2012 at 02:42:48PM +0200, Kurt Van Dijck wrote:
>> On Fri, Aug 24, 2012 at 01:28:16PM +0200, Marc Kleine-Budde wrote:
>>> On 08/24/2012 07:10 AM, Kurt Van Dijck wrote:
>>>> Hello,
>>>>
>>>> I find the CAN led triggers an interesting thing.
>>>>
>>>> And then, this scenario fell crossed my mind:
>>>> Imagine I do:
>>>> [insert CAN device: can0]
>>>> $ ip link set can0 name helga
>>>> [insert another CAN device: again 'can0']
>>>>
>>>> Registering 'can0-tx' led trigger will fail for the second CAN devic=
e,
>>>> since that led trigger name is already reserved for CAN device 'helg=
a'.
>>> Good point.
>=20
> Yep, thanks for pointing that out!
>=20
> Interface renaming was something I considered when I first wrote the
> code and I had the mac80211-led driver in mind, as that driver uses the=

> phy name and not the netdev one for its triggers.
>=20
> The reason why I did not care that much in the end is that on SoC based=

> systems trigger-led association is made at probe time, based on data
> either from platform_data or devicetree, so I imagined that once the
> kernel is ported to the board and default triggers are set correctly at=

> boot time, the userspace is free to rename CAN interfaces and nobody
> should notice... :^)
>=20
> The thing I did not consider are hot-plug interfaces mixed with
> renaming, such as in the case you pointed out - it's probably not reall=
y
> common but still possible.
>=20
>>>> I'm not sure how to fix such.
>>>> If 'rx' & 'tx' may be combined, reusing the netdev name may be possi=
ble?
>>>> Just wild thinking ...
>>>
>>> I think the device's name (not netdev) is unique in the system and
>>> cannot be changed.
>>
>> but may contain several netdev's ...
>=20
> Ouch.

The net->ifindex is unique. But it's only an integer. Usually can0 has a
ifindex !=3D 0, so a simple can%d is contra productive here.

Some pointers to related code:
http://lxr.free-electrons.com/source/drivers/base/core.c#L1847
http://lxr.free-electrons.com/source/drivers/base/core.c#L73
http://lxr.free-electrons.com/source/include/linux/device.h#L695

comments?

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig9D8A217EF256FB81A0C34C77
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBEpUsACgkQjTAFq1RaXHMZuQCgmIPr9CV88CQQQUCUHQ8xVS1L
hPUAn2nW1MDJDBqEGkPhw0t6qNRxmwxm
=1YVX
-----END PGP SIGNATURE-----

--------------enig9D8A217EF256FB81A0C34C77--
