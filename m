Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab0KYMIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 07:08:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37360 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab0KYMIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 07:08:50 -0500
Message-ID: <4CEE51CA.8010402@pengutronix.de>
Date: Thu, 25 Nov 2010 13:08:42 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: andrew.chih.howe.khor@intel.com, socketcan-core@lists.berlios.de,
        Samuel Ortiz <sameo@linux.intel.com>, margie.foster@intel.com,
        netdev@vger.kernel.org, Christian Pellegrin <chripell@fsfe.org>,
        linux-kernel@vger.kernel.org, yong.y.wang@intel.com,
        kok.howg.ewe@intel.com, joel.clark@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Wolfgang Grandegger <wg@grandegger.com>, qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v3] can: Topcliff: PCH_CAN driver: Add Flow
 control,
References: <4CE2434B.5050701@dsn.okisemi.com>	<4CE27796.2000206@pengutronix.de>	<007401cb87b1$a773b3d0$66f8800a@maildom.okisemi.com>	<4CE64167.2030405@pengutronix.de> <003201cb8a02$f05b15e0$66f8800a@maildom.okisemi.com> <4CEA2986.4080607@pengutronix.de> <000b01cb8b6b$d7542a90$66f8800a@maildom.okisemi.com> <4CED0650.7030004@pengutronix.de> <001b01cb8c98$d06aaa00$66f8800a@maildom.okisemi.com>
In-Reply-To: <001b01cb8c98$d06aaa00$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEF8E6FA0CEF6759DD0AFD3F9"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEF8E6FA0CEF6759DD0AFD3F9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/25/2010 01:03 PM, Tomoya MORINAGA wrote:
> On Wednesday, November 24, 2010 9:34 PM, Marc Kleine-Budde wrote :
>> On 11/24/2010 01:09 AM, Tomoya MORINAGA wrote:
>>> On Monday, November 22, 2010 5:27 PM, Marc Kleine-Budde wrote:
>>>>>>>> Still we have the busy waiting in the TX path. Maybe you can mov=
e the
>>>>>>>> waiting before accessing the if[1] and remove the busy waiting h=
ere.
>>>>>>> I can't understand your saying.
>>>>>>> For transmitting data, calling pch_can_rw_msg_obj is mandatory.
>>>>>> Yes, but the busy wait is not needed. It should be enough to do th=
e
>>>>>> busy-waiting _before_ accessing the if[1].
>>>>>
>>>>> Do you mean we should create other pch_can_rw_msg_obj which doesn't=
 have busy wait ?
>>>> ACK, and this non busy waiting is use in the TX path. But you add a =
busy
>>>> wait only function before accessing the if[1] in the TX path.
>>>
>>> The "busy waiting" of pch_can_rw_msg_obj is for next processing acces=
ses to Message object.
>>> If deleting this busy waiting, next processing can access to Message =
object, regardless previous transfer doesn't
>>> complete yet.
>>> Thus, I think, the "busy waiting" is necessary.
>>
>> Yes, it's necessary, but not where it is done currently.
>> Let me outline how I think the TX path should look like:
>>
>> pch_xmit() {
>> take_care_about_flow_control();
>> prepare_can_frame_to_be_copied_to_tx_if();
>>
>> /* most likely we don't have to wait here */
>> wait_until_tx_if_is_ready();
>>
>> copy_can_frame_to_tx_if();
>>
>> /* trigger tx in hardware */
>> send_tx_if_but_dont_do_busywait();
>>
>> /* tx_if is busy now, but before we access it, we'll check tx_if is re=
ady */
>> }
>=20
> This Tx path also has Read-Modify-Write for MessageRAM access.
> Do you mean Tx path shouldn't have Read-Modify-Write ?

Why do you Read-Modify-Write for TX? Naively speaking you just need to
push your Data into a Mail/IF/Whatever and push the send button.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigEF8E6FA0CEF6759DD0AFD3F9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkzuUcoACgkQjTAFq1RaXHN0mwCfc6Ph3bRd0E90dVNVBtBc6Gy6
eo8AnAowXty9cxu9sYOX+D2I5Sjh9aC1
=Ur55
-----END PGP SIGNATURE-----

--------------enigEF8E6FA0CEF6759DD0AFD3F9--
