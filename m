Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab0KVI2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 03:28:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56310 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab0KVI2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 03:28:06 -0500
Message-ID: <4CEA2986.4080607@pengutronix.de>
Date: Mon, 22 Nov 2010 09:27:50 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: andrew.chih.howe.khor@intel.com, socketcan-core@lists.berlios.de,
        Samuel Ortiz <sameo@linux.intel.com>, margie.foster@intel.com,
        netdev@vger.kernel.org, Christian Pellegrin <chripell@fsfe.org>,
        linux-kernel@vger.kernel.org, yong.y.wang@intel.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>, kok.howg.ewe@intel.com,
        joel.clark@intel.com, "David S. Miller" <davem@davemloft.net>,
        Wolfgang Grandegger <wg@grandegger.com>, qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v3] can: Topcliff: PCH_CAN driver: Add Flow
 control,
References: <4CE2434B.5050701@dsn.okisemi.com>	<4CE27796.2000206@pengutronix.de>	<007401cb87b1$a773b3d0$66f8800a@maildom.okisemi.com>	<4CE64167.2030405@pengutronix.de> <003201cb8a02$f05b15e0$66f8800a@maildom.okisemi.com>
In-Reply-To: <003201cb8a02$f05b15e0$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6AB79154414CF0941E795E6A"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6AB79154414CF0941E795E6A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/22/2010 06:05 AM, Tomoya MORINAGA wrote:
> On Friday, November 19, 2010 6:20 PM,  Marc Kleine-Budde wrote :
>=20
>>>>> - spin_unlock_irqrestore(&priv->msgif_reg_lock, flags);
>>>>> + pch_can_rw_msg_obj(&priv->regs->ifregs[1].creq, tx_obj_no);
>>>> Still we have the busy waiting in the TX path. Maybe you can move th=
e
>>>> waiting before accessing the if[1] and remove the busy waiting here.=

>>> I can't understand your saying.
>>> For transmitting data, calling pch_can_rw_msg_obj is mandatory.
>> Yes, but the busy wait is not needed. It should be enough to do the
>> busy-waiting _before_ accessing the if[1].
>=20
> Do you mean we should create other pch_can_rw_msg_obj which doesn't hav=
e busy wait ?

ACK, and this non busy waiting is use in the TX path. But you add a busy
wait only function before accessing the if[1] in the TX path.

cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig6AB79154414CF0941E795E6A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzqKYoACgkQjTAFq1RaXHOeXQCfT7VKvE6KPYvx51UzDh+mMJzd
hD8An2psKQO3bRnvocjSPOu3zAqs8Blw
=4RUa
-----END PGP SIGNATURE-----

--------------enig6AB79154414CF0941E795E6A--
