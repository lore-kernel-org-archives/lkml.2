Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab2JZKbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 06:31:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38392 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab2JZKbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 06:31:04 -0400
Message-ID: <508A665C.80107@pengutronix.de>
Date: Fri, 26 Oct 2012 12:30:52 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: Sascha Hauer <s.hauer@pengutronix.de>, kernel@pengutronix.de,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "tru@work-microwave.de" <tru@work-microwave.de>
Subject: Re: [PATCH 2/2] ARM: mach-imx: CAN clock fix for i.MX53
References: <1351164400-27940-1-git-send-email-stigge@antcom.de> <1351164400-27940-2-git-send-email-stigge@antcom.de> <20121026085934.GA1641@pengutronix.de> <508A54E4.2060108@antcom.de>
In-Reply-To: <508A54E4.2060108@antcom.de>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC898E9FA45354770F015320E"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC898E9FA45354770F015320E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/26/2012 11:16 AM, Roland Stigge wrote:
> Hi!
>=20
> On 10/26/2012 10:59 AM, Sascha Hauer wrote:
>> On Thu, Oct 25, 2012 at 01:26:40PM +0200, Roland Stigge wrote:
>>> This patch fixes CAN clocking on i.MX53.
>>>
>>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>>>
>>> ---
>>>  arch/arm/mach-imx/clk-imx51-imx53.c |    8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> --- linux-2.6.orig/arch/arm/mach-imx/clk-imx51-imx53.c
>>> +++ linux-2.6/arch/arm/mach-imx/clk-imx51-imx53.c
>>> @@ -426,10 +426,10 @@ int __init mx53_clocks_init(unsigned lon
>>>  	clk[usb_phy2_gate] =3D imx_clk_gate2("usb_phy2_gate", "usb_phy_sel"=
, MXC_CCM_CCGR4, 12);
>>>  	clk[can_sel] =3D imx_clk_mux("can_sel", MXC_CCM_CSCMR2, 6, 2,
>>>  				mx53_can_sel, ARRAY_SIZE(mx53_can_sel));
>>> -	clk[can1_serial_gate] =3D imx_clk_gate2("can1_serial_gate", "can_se=
l", MXC_CCM_CCGR6, 22);
>>> -	clk[can1_ipg_gate] =3D imx_clk_gate2("can1_ipg_gate", "ipg", MXC_CC=
M_CCGR6, 20);
>>> -	clk[can2_serial_gate] =3D imx_clk_gate2("can2_serial_gate", "can_se=
l", MXC_CCM_CCGR4, 8);
>>> -	clk[can2_ipg_gate] =3D imx_clk_gate2("can2_ipg_gate", "ipg", MXC_CC=
M_CCGR4, 6);
>>
>> I just rechecked. The above matches the i.MX53 Reference Manual rev 2.=
1

An old rev 1 manual has lists the same bits.

>>> +	clk[can1_serial_gate] =3D imx_clk_gate2("can1_serial_gate", "can_se=
l", MXC_CCM_CCGR4, 6);
>>> +	clk[can1_ipg_gate] =3D imx_clk_gate2("can1_ipg_gate", "ipg", MXC_CC=
M_CCGR4, 8);
>>> +	clk[can2_serial_gate] =3D imx_clk_gate2("can2_serial_gate", "can_se=
l", MXC_CCM_CCGR4, 6);
>>> +	clk[can2_ipg_gate] =3D imx_clk_gate2("can2_ipg_gate", "ipg", MXC_CC=
M_CCGR4, 8);
>>
>> This doesn't.
>=20
> This may be right, but unfortunately, since the introduction of your
> can1 + can2 clocking change, the first block stopped working for me.

You are effectively using can2's clock for can1. Are you sure you
haven't mixed up can1 and can2?

> My above patch is basically a rollback which works for the first block.=

>=20
> An interesting hint is: can2 (which was the only one defined _before_
> your can1 + can2 change) didn't work before and afterwards at all. (But=

> I'm not using it anyway.)

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigC898E9FA45354770F015320E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlCKZmAACgkQjTAFq1RaXHPrZACeKEjSK9DO1HxNo88lqDBhsBXU
UUIAnim5gg/QsBF1WPL9tnt8gyXSKBQA
=Itv2
-----END PGP SIGNATURE-----

--------------enigC898E9FA45354770F015320E--
