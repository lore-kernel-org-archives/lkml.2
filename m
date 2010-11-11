Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0KKKEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:04:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33850 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab0KKKEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:04:52 -0500
Message-ID: <4CDBBFB7.70806@pengutronix.de>
Date: Thu, 11 Nov 2010 11:04:39 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, andrew.chih.howe.khor@intel.com,
        qi.wang@intel.com, margie.foster@intel.com, yong.y.wang@intel.com,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 v2] can: Topcliff: PCH_CAN driver: Fix build
 warnings
References: <005301cb7ffa$5b63cd90$66f8800a@maildom.okisemi.com> <00fe01cb8009$62e11410$66f8800a@maildom.okisemi.com> <4CD945B4.4060408@pengutronix.de> <002501cb8186$b56a6280$66f8800a@maildom.okisemi.com>
In-Reply-To: <002501cb8186$b56a6280$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEAC1BD5DD8E5F0D1A31083FD"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEAC1BD5DD8E5F0D1A31083FD
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: quoted-printable

On 11/11/2010 10:56 AM, Tomoya MORINAGA wrote:
>>>>> + if (priv->tx_obj =3D=3D (PCH_OBJ_NUM + 1)) { /* Point tail Obj + =
1 */
>>>>> +  while (ioread32(&priv->regs->treq2) & 0xfc00)
>>>>> +   udelay(1);
>>>
>>> When points tail of Tx message object,
>>> this driver waits until completion of all tx messaeg objects.
>>
>> Looping busy it not an option here.
>>
>>> Thus, application/driver ought not to be able to put Tx object exceed=
 the number of tx message object.
>>> Thus I think these code(netif_stop_queue/netif_wake_queue) are comple=
tely redundant.
>>
>> Nope - please remove the waiting completely and convert your flow
>> control to netif_stop_queue/netif_wake_queue.
>>
>=20
> I see.
> I will remove like above.
>=20
> BTW, Let me know the reason.
> Could you explain the reason why you deny looping busy loop ?

That would kill performance.

cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigEAC1BD5DD8E5F0D1A31083FD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzbv7sACgkQjTAFq1RaXHMUsgCfU4InjhlY4IYTO5xwHD6wOOQk
12kAn291ha7SfRpl2bC5KWVJe8L+EQsH
=jGR6
-----END PGP SIGNATURE-----

--------------enigEAC1BD5DD8E5F0D1A31083FD--
