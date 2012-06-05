Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206Ab2FENWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:22:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52013 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761355Ab2FENWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:22:11 -0400
Message-ID: <4FCE07EE.40003@pengutronix.de>
Date: Tue, 05 Jun 2012 15:21:50 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: bhupesh.sharma@st.com, federico.vaga@gmail.com, alan@lxorguk.ukuu.org.uk,
        wg@grandegger.com, giancarlo.asnaghi@st.com, alan@linux.intel.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] c_can_pci: generic module for c_can on PCI
References: <D5ECB3C7A6F99444980976A8C6D896384FA5EC4DFC@EAPEX1MAIL1.st.com>  <4FC135C6.5030206@grandegger.com> <1677842.Pq7naXsvrI@harkonnen>  <D5ECB3C7A6F99444980976A8C6D896384FA5EC4B37@EAPEX1MAIL1.st.com>  <3650428.HarNR9HfNF@harkonnen> <20120605131337.GA15432@mail.gnudd.com>
In-Reply-To: <20120605131337.GA15432@mail.gnudd.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig26790ADC94E0DA9C5DC423CA"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig26790ADC94E0DA9C5DC423CA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/05/2012 03:13 PM, Alessandro Rubini wrote:
>>> My implementation is align to 32, but I'm trying to make a generic PC=
I
>>> wrapper (some other could be aligned to 16)
> =20
>> So it means your implementation is also flaky and you are probably
>> wasting HW memory space while integrating the Bosch C_CAN module in
>> your SoC :)
>=20
> Then I may say _your_ implementation is flaky because it wastes one
> bit in the address decoder and a lot of logic gates in the data
> bus. It's normal to align registers at 32 bits, as it's simpler and
> faster.  Most SoCs have only 32-bit aligned registers, for a reason.
>=20
>> I am not a big fan of adding platform specific flakes in any core
>> file, that why we keep the platform file separate from the core
>> ones.
>=20
> A number of other drivers have a shift parameter, because it's very
> common for the hardware integrator to feel free to choose the easiest
> wiring for the device.  The choice to keep the platform driver
> separate from the core driver only adds complication in my opinion:
> you need to export 4 symbols and yhen every user must duplicate code
> (like federico is replicating theplatform driver in the pci driver).
>=20
> I'd really prefer to have the core driver be a platform driver, and
> the others just add platform data to describe how it is wired. That's
> actually the reason why the platform bus exists.
>=20
>> But I will left Marc and Wolfgang to further comment on the same.
>=20
> I agree: let them decide.

I personally like the "pci device sets up a platform device" idea.

My question is, is this considered being a good practise?

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig26790ADC94E0DA9C5DC423CA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk/OB/QACgkQjTAFq1RaXHPF3gCfXpN9LcfI7Au/TIn0VKXfKXdZ
taUAoJfxxptrbW1MQI6N7suEyjeZ2Duv
=qSFF
-----END PGP SIGNATURE-----

--------------enig26790ADC94E0DA9C5DC423CA--
