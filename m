Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab2JZOFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:05:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41817 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab2JZOFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:05:46 -0400
Message-ID: <508A98AC.1000000@pengutronix.de>
Date: Fri, 26 Oct 2012 16:05:32 +0200
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
References: <1351164400-27940-1-git-send-email-stigge@antcom.de> <1351164400-27940-2-git-send-email-stigge@antcom.de> <20121026085934.GA1641@pengutronix.de> <508A54E4.2060108@antcom.de> <508A665C.80107@pengutronix.de> <508A6E92.1000107@antcom.de> <508A95B3.3010306@antcom.de>
In-Reply-To: <508A95B3.3010306@antcom.de>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5CD69C15E6DEAFF6878D81F0"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5CD69C15E6DEAFF6878D81F0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/26/2012 03:52 PM, Roland Stigge wrote:
> On 10/26/2012 01:05 PM, Roland Stigge wrote:
>> On 10/26/2012 12:30 PM, Marc Kleine-Budde wrote:
>>>>>> +	clk[can1_serial_gate] =3D imx_clk_gate2("can1_serial_gate",
>>>>>> "can_sel", MXC_CCM_CCGR4, 6); +	clk[can1_ipg_gate] =3D
>>>>>> imx_clk_gate2("can1_ipg_gate", "ipg", MXC_CCM_CCGR4, 8); +
>>>>>> clk[can2_serial_gate] =3D imx_clk_gate2("can2_serial_gate",
>>>>>> "can_sel", MXC_CCM_CCGR4, 6); +	clk[can2_ipg_gate] =3D
>>>>>> imx_clk_gate2("can2_ipg_gate", "ipg", MXC_CCM_CCGR4, 8);
>>>>>
>>>>> This doesn't.
>>>>
>>>> This may be right, but unfortunately, since the introduction of
>>>> your can1 + can2 clocking change, the first block stopped working
>>>> for me.
>>>
>>> You are effectively using can2's clock for can1. Are you sure you=20
>>> haven't mixed up can1 and can2?
>>
>> Just using the above patch and patch 1/2 from this series (missing can=

>> pinmuxing), doing like this in custom .dts:
>>
>> +                       can1: can@53fc8000 {
>> +                               pinctrl-names =3D "default";
>> +                               pinctrl-0 =3D <&pinctrl_can1_1>;
>> +                               clock-frequency =3D <66500000>;
>=20
> That was the problem, since in flexcan.c probe():
>=20
>=20
> 	if (pdev->dev.of_node)
> 		of_property_read_u32(pdev->dev.of_node,
> 						"clock-frequency", &clock_freq);
>=20
> 	if (!clock_freq) {
> 		clk_ipg =3D devm_clk_get(&pdev->dev, "ipg");
> 		if (IS_ERR(clk_ipg)) {
> 			dev_err(&pdev->dev, "no ipg clock defined\n");
> 			err =3D PTR_ERR(clk_ipg);
> 			goto failed_clock;
> 		}
> 		clock_freq =3D clk_get_rate(clk_ipg);
>=20
> 		clk_per =3D devm_clk_get(&pdev->dev, "per");
> 		if (IS_ERR(clk_per)) {
> 			dev_err(&pdev->dev, "no per clock defined\n");
> 			err =3D PTR_ERR(clk_per);
> 			goto failed_clock;
> 		}
> 	}
>=20
> Sorry for the noise.

We have the possibility to specify the clock frequency in the device
tree as the power pc has no support for generic clock yet.

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig5CD69C15E6DEAFF6878D81F0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlCKmK8ACgkQjTAFq1RaXHNhBACgkxv2oz7ieB5tsQD64jdo8KSx
skUAniEXgBpfSJL3X4t4qu+W+U2Pwb1U
=XRen
-----END PGP SIGNATURE-----

--------------enig5CD69C15E6DEAFF6878D81F0--
