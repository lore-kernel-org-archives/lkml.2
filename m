Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab2K0PTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:19:46 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47873 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab2K0PTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:19:43 -0500
Message-ID: <50B4D9E9.8070607@ti.com>
Date: Tue, 27 Nov 2012 17:19:05 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Tomi Valkeinen <tomba@iki.fi>, Alex Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com> <20121121114018.GA31576@avionic-0098.adnet.avionic-design.de> <50ACC341.3090204@ti.com> <6982060.HfOokt4dIn@avalon>
In-Reply-To: <6982060.HfOokt4dIn@avalon>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigC3E0CFC8B85771E592207121"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigC3E0CFC8B85771E592207121
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-11-27 17:08, Laurent Pinchart wrote:
> Hi Tomi,
>=20
> On Wednesday 21 November 2012 14:04:17 Tomi Valkeinen wrote:
>> On 2012-11-21 13:40, Thierry Reding wrote:
>=20
> [snip]
>=20
>>> One thing that's not very clear is how the backlight subsystem should=
 be
>>> wired up with the display framework. I have a patch on top of the Teg=
ra
>>> DRM driver which adds some ad-hoc display support using this power
>>> sequences series and the pwm-backlight.
>>
>> I think that's a separate issue: how to associate the lcd device and
>> backlight device together. I don't have a clear answer to this.
>>
>> There are many ways the backlight may be handled. In some cases the
>> panel and the backlight are truly independent, and you can use the oth=
er
>> without using the other (not very practical, though =3D).
>=20
> From a control point of view that's always the case for DPI panels (as =
those=20
> panels have no control bus, the backlight control bus is by definition =

> separate) and is the case for the two DBI panels I've seen (but I won't=
 claim=20
> that's a significative number of panels).

They may have a control bus, I2C, SPI, etc. In some cases that can be
used to control the backlight. But yes, it's separate from the video bus.=


>> But then with some LCDs the backlight may be controlled by sending com=
mands
>> to the panel, and in this case the two may be quite linked. Changing t=
he
>> backlight requires the panel driver to be up and running, and sometime=
s the
>> sending the backlight commands may need to be (say, DSI display, with
>> backlight commands going over the DSI bus).
>=20
> When you write "sending commands to the panel", do you mean on the same=
=20
> control bus that the panel use ? Or would that also include for instanc=
e an=20
> I2C backlight controller integrated inside a DSI panel module ? In the =
later=20

I mean the same control bus that is used to control the panel, be it
shared with video bus like DSI, or separate like I2C.

> case there might still be dependencies between the panel controller and=
 the=20
> backlight controller (let's say for instance that the panel controller =
has a=20
> DSI-controller GPIO wired to the backlight controller reset signal), bu=
t in=20
> practice I don't know if that's ever the case.
>=20
>> So my feeling is that the panel driver should know about the related
>> backlight device. In the first case the panel driver would just call
>> enable/disable in the backlight device when the panel is turned on.
>=20
> That makes sense. Unless I'm mistaken a backlight is always associated =
with a=20
> panel (it would be called a light if there was no panel in front of it)=
=2E We=20
> can thus expose backlight operations in the panel CDF (in-kernel) API. =
The=20
> panel driver would need a way to retrieve a pointer to the associated=20
> backlight device.

I agree.

>> In the second case of the DSI panel... I'm not sure. I've implemented =
it
>> so that the panel driver creates the backlight device, and implements
>> the backlight callbacks. It then sends the DSI commands from those
>> callbacks.
>=20
> If we decide to make the panel expose backlight operations we could get=
 rid of=20
> the backlight device in this case.

Do you mean there would be a real backlight device only when there's a
totally independent backlight for the panel?

 Tomi



--------------enigC3E0CFC8B85771E592207121
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQtNnpAAoJEPo9qoy8lh71/mUP/jp7Ck10+BR5mARghLUQCHYL
teKtrxebnNfTzqW4PQX3Iv5FB54RIIyADvqKmXCHV0f6eptCSSq68oVl3x095qx8
ycDwIUxSm/X4QQhdfoZA0UgjecL9wPnDUaR/QJE+u+SlinQnkT2/rPITX9H18o8S
7dwxePH9y+Qsp/1rPIVj0+wQCCDr1rt006vkACsrG5AHeoIIJrilSH5qBa9uwDh9
pIokO2jgmoQMBgAzUnIWCOugHj19GIGNkGfFShvkEYd9MOuQV0/m+jTA2IS0ZCbR
9kNYAb1zay18/mdbBfLLj4yWqhVegBabvUDkyjxh46BEZRDD2q6RcEHofIanP4hl
55+mMRjmo6qAlESZfDTPgkQVI/Zo+B5JgwKEqw8qrYyg0BMG1wwBSeLHJNJGgdwQ
cEFQRKboWT1do/bpNo9o04CuaniR1WMw1xp5M0EX4JNCB/EO8WJfVSuWK9sTy6u/
eR6s7z0YImtj19J6heAlzHgjBJbJ45QNH4XHmiUK0lFs47OpwzPxLaOE68PYAGLx
Ua28CwTuZzMQmVL3J7nw/ZIeN2qgeG79aPLBqMgMTruLAKTSLLRyxbbfMDwAWrGa
9L7HGV0cHKTIFsPXnkGUvsE2nUFj6IDMsOkvToZL952Qg+IYJkiDHSp17XbbBibr
46mZdMAg5XfND4diMeqm
=X93Q
-----END PGP SIGNATURE-----

--------------enigC3E0CFC8B85771E592207121--
